from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

# === Cargar variables de entorno ===

# Ruta absoluta al archivo .env (desde raíz del proyecto)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
dotenv_path = os.path.join(BASE_DIR, ".env")
load_dotenv(dotenv_path)

# === Configuración de la base de datos ===

DB_USER = os.getenv("MYSQL_USER")
DB_PASSWORD = os.getenv("MYSQL_PASSWORD")
DB_HOST = os.getenv("MYSQL_HOST", "localhost")  # default a localhost por seguridad
DB_NAME = os.getenv("MYSQL_DATABASE")

# Validar configuración en entorno de producción
if not all([DB_USER, DB_PASSWORD, DB_NAME]):
    raise EnvironmentError(
        "Faltan variables de entorno requeridas para la base de datos"
    )

DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:3306/{DB_NAME}"

# === Configuración del motor de SQLAlchemy ===

engine = create_engine(DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# === Dependencia para FastAPI: sesión de base de datos ===


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
