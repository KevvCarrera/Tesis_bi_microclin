import streamlit as st
import pandas as pd
import numpy as np
from statsmodels.tsa.arima.model import ARIMA
from sklearn.metrics import mean_squared_error, mean_absolute_error
import matplotlib.pyplot as plt
import sqlalchemy

# Configurar la conexión a la base de datos
# Reemplaza 'user', 'password', 'host', 'database' con los datos de tu conexión
engine = sqlalchemy.create_engine('mysql+pymysql://firetens_firetens:3Nwb+B^QSh1c@50.116.27.100/firetens_microclin')

# Definir la consulta SQL
query = """
SELECT 
    idEnfermedad,
    anio,
    semana,
    mes,
    fecha,
    enfermedad,
    SUBSTRING_INDEX(localizacion, ',', 1) AS Provincia,
    SUBSTRING_INDEX(SUBSTRING_INDEX(localizacion, ',', 2), ',', -1) AS Distrito,
    SUBSTRING_INDEX(localizacion, ',', -1) AS Departamento,
    nNotificacion,
    CAST(SUBSTRING_INDEX(animalesSuceptibles, ' ', 1) AS UNSIGNED) AS animalesSuceptibles,
    CAST(SUBSTRING_INDEX(nCasos, ' ', 1) AS UNSIGNED) AS nCasos,
    CAST(SUBSTRING_INDEX(nAnimalesMuertos, ' ', 1) AS UNSIGNED) AS nAnimalesMuertos,
    SUBSTRING_INDEX(animalesSuceptibles, ' ', -1) AS Especie,
    CASE 
        WHEN dxLab LIKE 'Negativo%%' THEN 'Negativo'
        WHEN dxLab LIKE 'Positivo%%' THEN 'Positivo'
        WHEN dxLab LIKE 'En Proceso%%' THEN 'En Proceso'
        ELSE NULL
    END AS dxLab
FROM 
    firetens_microclin.enfermedad
WHERE 
    localizacion LIKE '%%,%%,%%';
"""

# Cargar los datos desde la base de datos con manejo de errores
try:
    df = pd.read_sql_query(query, engine)
    st.success("Datos cargados exitosamente.")
except Exception as e:
    st.error(f"Error al cargar los datos: {e}")
    df = None  # Asegurarse de que df esté definido

# Verificar si df contiene datos antes de continuar
if df is not None and not df.empty:
    # Configuración de Streamlit
    st.title('Pronóstico de Enfermedades')
    st.image("logo_microclin.png", use_column_width=True)
    st.write("Esta aplicación utiliza ARIMA para predecir los casos de enfermedades basados en los datos proporcionados.")
    
    # Convertir la columna de fechas a tipo datetime
    df['fecha'] = pd.to_datetime(df['fecha'], format='%d/%m/%Y')
    
    # Añadir filtros de fecha y especie
    st.sidebar.header("Filtros")
    fecha_min = st.sidebar.date_input("Fecha mínima", df['fecha'].min().date())
    fecha_max = st.sidebar.date_input("Fecha máxima", df['fecha'].max().date())
    especie_seleccionada = st.sidebar.multiselect("Seleccionar especie", options=df['Especie'].unique(), default=df['Especie'].unique())

    # Aplicar los filtros
    df_filtrado = df[(df['fecha'] >= pd.Timestamp(fecha_min)) & (df['fecha'] <= pd.Timestamp(fecha_max))]
    df_filtrado = df_filtrado[df_filtrado['Especie'].isin(especie_seleccionada)]
    
    # Verificar si el filtro dejó datos
    if not df_filtrado.empty:
        st.subheader("Resumen de Especies")
        especies_resumen = df_filtrado['Especie'].value_counts()
        st.write("Distribución de casos por tipo de especie:")
        st.bar_chart(especies_resumen)
        
        # Detalles de especies únicas en el DataFrame filtrado
        st.write("Tipos de especies presentes en los datos filtrados:")
        st.dataframe(df_filtrado[['Especie']].drop_duplicates().reset_index(drop=True))
        
        # Preparar los datos para la serie temporal
        df_filtrado = df_filtrado.set_index('fecha')
        df_filtrado.sort_index(inplace=True)
        
        # Seleccionar la columna a predecir, por ejemplo, 'nCasos'
        serie = df_filtrado['nCasos'].dropna()
        
        # Visualizar los datos
        st.line_chart(serie)
        
        # Entrenar el modelo ARIMA
        p, d, q = 5, 1, 0  # Ajusta estos parámetros según tu análisis
        model = ARIMA(serie, order=(p, d, q))
        model_fit = model.fit()
        
        # Predecir y mostrar resultados
        predicciones = model_fit.forecast(steps=30)  # Predicción de 30 días
        
        # Explicación del método de predicción
        st.subheader("Método de Predicción Utilizado")
        st.write("""
        El modelo utilizado para la predicción es un modelo ARIMA (AutoRegressive Integrated Moving Average), 
        que es un método estadístico para analizar y predecir series temporales. Este método utiliza dependencias 
        entre datos pasados para estimar futuros valores.
        """)
        
        # Visualización de predicciones
        st.subheader("Predicciones para los próximos 30 días")
        st.write("Este gráfico muestra la proyección de los casos de enfermedades para los próximos 30 días.")
        plt.figure(figsize=(10, 5))
        plt.plot(serie.index, serie, label='Datos Reales')
        plt.plot(pd.date_range(serie.index[-1], periods=31, freq='D')[1:], predicciones, label='Predicciones', color='orange')
        plt.xlabel("Fecha")
        plt.ylabel("Número de Casos")
        plt.title("Predicciones ARIMA de Casos de Enfermedades")
        plt.legend()
        st.pyplot(plt)
        
        # Evaluar el modelo con KPIs
        train_size = int(len(serie) * 0.8)
        train, test = serie[:train_size], serie[train_size:]
        
        model = ARIMA(train, order=(p, d, q))
        model_fit = model.fit()
        predicciones_test = model_fit.forecast(steps=len(test))
        
        # Calcular KPIs
        mse = mean_squared_error(test, predicciones_test)
        mae = mean_absolute_error(test, predicciones_test)
        rmse = np.sqrt(mse)
        
        # Mostrar los KPIs
        st.subheader("KPIs del Modelo")
        st.write(f"Mean Absolute Error (MAE): {mae:.2f}")
        st.write(f"Mean Squared Error (MSE): {mse:.2f}")
        st.write(f"Root Mean Squared Error (RMSE): {rmse:.2f}")
        
        # Mostrar gráfico de comparación
        st.subheader("Comparación de Datos Reales vs Predicciones en el Período de Prueba")
        plt.figure(figsize=(10, 5))
        plt.plot(test.index, test, label='Datos Reales')
        plt.plot(test.index, predicciones_test, color='red', label='Predicciones')
        plt.xlabel("Fecha")
        plt.ylabel("Número de Casos")
        plt.title("Comparación de Datos Reales y Predicciones")
        plt.legend()
        st.pyplot(plt)
    else:
        st.warning("No hay datos disponibles con los filtros seleccionados.")
else:
    st.warning("No hay datos disponibles para mostrar o la carga falló.")
