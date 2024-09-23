import pdfplumber

# Ruta pdfo
pdf_path = "D:/Proyectos/Tesis_bi_microclin/read_pdf/pdf/pdf1.pdf"

# Abre el archivo PDF
with pdfplumber.open(pdf_path) as pdf:
    for page_num, page in enumerate(pdf.pages, start=1):
        text = page.extract_text()
        print(f"--- Página {page_num} ---\n")
        print(text)  
        
        with open("datos_extraidos.txt", "a", encoding="utf-8") as f:
            f.write(f"--- Página {page_num} ---\n")
            f.write(text)
            f.write("\n")

print("Extracción completada.")
