import os
from dotenv import load_dotenv
from pathlib import Path

# Buscar .env en la carpeta padre de /backend
env_path = Path(__file__).resolve().parent.parent / ".env"

print("📄 Buscando .env en:", env_path)
print("¿Existe el archivo?:", env_path.exists())

# Cargar el .env desde esa ruta
load_dotenv(dotenv_path=env_path)

# Leer algunas variables
print("🌐 CORS_ORIGINS =", os.getenv("CORS_ORIGINS"))
print("🔐 MYSQL_USER =", os.getenv("MYSQL_USER"))
print("🛠️ ENV =", os.getenv("ENV"))
