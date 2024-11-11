import streamlit as st
import pyodbc
import pandas as pd
import os

# Configuración de las credenciales
server = os.getenv('SQL_SERVER', 'KEVV\\SQLExpress')
database = os.getenv('SQL_DATABASE', 'streamlit_prueba')
username = os.getenv('SQL_USERNAME', 'sa')
password = os.getenv('SQL_PASSWORD', '.')

# Conexión a SQL Server
try:
    conn = pyodbc.connect(
        'DRIVER={SQL SERVER};'
        f'SERVER={server};'
        f'DATABASE={database};'
        'Trusted_Connection=yes;'
    )
    cursor = conn.cursor()
    print("Conectado exitosamente a la base de datos.")
except pyodbc.Error as e:
    print(f"Error al conectar a la base de datos: {e}")

# Crear tabla
def create_table():
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS mytable (
            id INT PRIMARY KEY,
            name VARCHAR(50),
            age INT
        )
    ''')
    conn.commit()

# Insertar datos
def add_data(id, name, age):
    cursor.execute('''
        INSERT INTO mytable (id, name, age) VALUES (?, ?, ?)
    ''', (id, name, age))
    conn.commit()

# Leer datos
def view_data():
    cursor.execute('SELECT * FROM mytable')
    data = cursor.fetchall()
    return data

# Actualizar datos
def update_data(id, name, age):
    cursor.execute('''
        UPDATE mytable SET name = ?, age = ? WHERE id = ?
    ''', (name, age, id))
    conn.commit()

# Eliminar datos
def delete_data(id):
    cursor.execute('''
        DELETE FROM mytable WHERE id = ?
    ''', (id,))
    conn.commit()

# Interfaz de usuario con Streamlit
st.title("Aplicación CRUD con Streamlit y SQL Server")

menu = ["Crear", "Leer", "Actualizar", "Eliminar"]
choice = st.sidebar.selectbox("Menú", menu)

if choice == "Crear":
    st.subheader("Agregar Datos")
    id = st.number_input("ID", min_value=1)
    name = st.text_input("Nombre")
    age = st.number_input("Edad", min_value=1)
    if st.button("Agregar"):
        add_data(id, name, age)
        st.success(f"Datos de {name} agregados exitosamente")

elif choice == "Leer":
    st.subheader("Ver Datos")
    data = view_data()
    df = pd.DataFrame(data, columns=["ID", "Nombre", "Edad"])
    st.dataframe(df)

elif choice == "Actualizar":
    st.subheader("Actualizar Datos")
    id = st.number_input("ID", min_value=1)
    name = st.text_input("Nuevo Nombre")
    age = st.number_input("Nueva Edad", min_value=1)
    if st.button("Actualizar"):
        update_data(id, name, age)
        st.success(f"Datos de {id} actualizados exitosamente")

elif choice == "Eliminar":
    st.subheader("Eliminar Datos")
    id = st.number_input("ID", min_value=1)
    if st.button("Eliminar"):
        delete_data(id)
        st.success(f"Datos de {id} eliminados exitosamente")
