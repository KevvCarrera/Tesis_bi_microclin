import pdfplumber
import os
from datetime import datetime

# Ruta del PDF
pdf_path = "D:/Proyectos/Tesis_bi_microclin/read_pdf/pdf/pdf1.pdf"

# Ruta de la carpeta export_txt
export_dir = "D:/Proyectos/Tesis_bi_microclin/read_pdf/export_txt"

# Crear la carpeta export_txt si no existe
if not os.path.exists(export_dir):
    os.makedirs(export_dir)

current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")

output_file = os.path.join(export_dir, f"datos_extraidos_{current_time}.txt")

# Abre el archivo PDF
with pdfplumber.open(pdf_path) as pdf:
    for page_num, page in enumerate(pdf.pages, start=1):
        text = page.extract_text()
        print(f"--- Página {page_num} ---\n")
        print(text)  
        
        # Guardar el texto extraído en el archivo
        with open(output_file, "a", encoding="utf-8") as f:
            f.write(f"--- Página {page_num} ---\n")
            f.write(text)
            f.write("\n")

print(f"Extracción completada. Los datos han sido guardados en {output_file}")
