import os
import shutil
import sqlparse

# Ruta base de los archivos
BASE_PATH = r"D:\Proyectos\Tesis_bi_microclin\sql_to_mysql"
MYSQL_PATH = os.path.join(BASE_PATH, 'mysql')
SQLSERVER_PATH = os.path.join(BASE_PATH, 'sqlserver')

def convert_mysql_to_sqlserver(sql):
    # Conversiones más precisas para SQL Server
    sql = sql.replace('AUTO_INCREMENT', 'IDENTITY(1,1)')  # Conversion de AUTO_INCREMENT
    sql = sql.replace('TINYINT', 'SMALLINT')               # Tipos de datos
    sql = sql.replace('TEXT', 'VARCHAR(MAX)')
    sql = sql.replace('LONGTEXT', 'VARCHAR(MAX)')
    sql = sql.replace('MEDIUMTEXT', 'VARCHAR(MAX)')
    sql = sql.replace('DATETIME', 'DATETIME2')             # DATETIME2 es mejor en SQL Server
    sql = sql.replace('INT UNSIGNED', 'INTEGER')           # Eliminar UNSIGNED, no existe en SQL Server
    sql = sql.replace('DOUBLE', 'FLOAT')                   # MySQL usa DOUBLE, SQL Server usa FLOAT

    # Reemplazar comillas invertidas para nombres de columnas y tablas
    sql = sql.replace('`', '') 

    # Convertir funciones específicas de MySQL a SQL Server (por ejemplo, NOW() a GETDATE())
    sql = sql.replace('NOW()', 'GETDATE()')

    # Convertir LIMIT a TOP
    sql = convert_limit_to_top(sql)

    # Asegurarse de que cada consulta termine con GO
    sql = add_go_to_queries(sql)

    return sql

def convert_limit_to_top(sql):
    """Convierte la cláusula LIMIT de MySQL a TOP de SQL Server"""
    lines = sql.splitlines()
    new_sql = []
    for line in lines:
        if 'LIMIT' in line.upper():
            limit_value = line.split('LIMIT')[-1].strip()
            new_sql[-1] = new_sql[-1].replace('SELECT', f'SELECT TOP {limit_value}')
        else:
            new_sql.append(line)
    return '\n'.join(new_sql)

def add_go_to_queries(sql):
    """Agrega 'GO' al final de cada consulta o bloque de consultas"""
    parsed = sqlparse.parse(sql)
    formatted_sql = []
    for statement in parsed:
        formatted_sql.append(str(statement).strip())
        formatted_sql.append("GO")  # Añadir 'GO' después de cada sentencia
    return '\n'.join(formatted_sql)

def process_sql_files():
    # Verificar si las carpetas existen
    if not os.path.exists(SQLSERVER_PATH):
        os.makedirs(SQLSERVER_PATH)

    # Procesar cada archivo .sql en la carpeta MySQL
    for filename in os.listdir(MYSQL_PATH):
        if filename.endswith(".sql"):
            mysql_file_path = os.path.join(MYSQL_PATH, filename)
            sqlserver_file_path = os.path.join(SQLSERVER_PATH, filename)

            # Leer el archivo .sql de MySQL
            with open(mysql_file_path, 'r', encoding='utf-8') as f:
                sql_content = f.read()

            # Convertir el contenido a SQL Server
            converted_sql = convert_mysql_to_sqlserver(sql_content)

            # Guardar el archivo convertido en la carpeta SQL Server
            with open(sqlserver_file_path, 'w', encoding='utf-8') as f:
                f.write(sqlparse.format(converted_sql, reindent=True, keyword_case='upper'))

            # Eliminar el archivo original de MySQL
            os.remove(mysql_file_path)
            print(f"Archivo convertido y movido a {sqlserver_file_path}")

if __name__ == "__main__":
    process_sql_files()
