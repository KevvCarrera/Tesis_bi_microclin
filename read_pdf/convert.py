import pdfplumber
import pandas as pd

def extract_data_from_pdf(pdf_path):
    data = {
        "AÑO": [],
        "MES": [],
        "SEM": [],
        "FECHA": [],
        "Enfermedad": [],
        "Localización: distrito, provincia, departamento": [],
        "N° de notificación": [],
        "N° de animales susceptibles": [],
        "N° Casos": [],
        "N° de animales muertos": [],
        "Dx Lab": []
    }

    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            text = page.extract_text().split("\n")
            for line in text:
                # Parse each line of the PDF into the corresponding section
                if 'AÑO' in line:
                    data["AÑO"].append(line.split(":")[-1].strip())
                elif 'MES' in line:
                    data["MES"].append(line.split(":")[-1].strip())
                elif 'SEM' in line:
                    data["SEM"].append(line.split(":")[-1].strip())
                elif 'FECHA' in line:
                    data["FECHA"].append(line.split(":")[-1].strip())
                else:
                    # Logic for parsing the table data
                    columns = line.split()
                    if len(columns) >= 7:  # Assuming 7 columns in the data
                        data["Enfermedad"].append(columns[0])
                        data["Localización: distrito, provincia, departamento"].append(columns[1])
                        data["N° de notificación"].append(columns[2])
                        data["N° de animales susceptibles"].append(columns[3])
                        data["N° Casos"].append(columns[4])
                        data["N° de animales muertos"].append(columns[5])
                        data["Dx Lab"].append(columns[6])

    # Ensure all lists are of the same length
    max_length = max(len(v) for v in data.values())
    for key in data:
        while len(data[key]) < max_length:
            data[key].append("")  # Fill missing values with empty strings

    return pd.DataFrame(data)

def save_to_excel(dataframes, output_excel):
    with pd.ExcelWriter(output_excel, engine='xlsxwriter') as writer:
        for sheet_name, df in dataframes.items():
            df.to_excel(writer, sheet_name=sheet_name, index=False)

# Cargar el archivo PDF
pdf_file_path = '5052195-reporte-semana-03.pdf'

# Extraer los datos del PDF
data_df = extract_data_from_pdf(pdf_file_path)

# Dividir las secciones en hojas
dataframes = {
    'Sección 1': data_df,  # Puedes ajustar las hojas según las secciones extraídas
    # 'Sección 2': df_section2, etc.
}

# Guardar en un archivo Excel con hojas separadas
save_to_excel(dataframes, 'reporte_generado.xlsx')

print("Archivo Excel generado con éxito.")
