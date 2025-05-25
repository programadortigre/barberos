from fastapi import FastAPI
import mysql.connector
from pydantic import BaseModel
from typing import List

app = FastAPI()

# Conexión a MySQL
def get_db_connection():
    conn = mysql.connector.connect(
        host="mysql",  # Nombre del contenedor de MySQL
        user="user",
        password="userpassword",
        database="barberia"
    )
    return conn

# Modelo de ejemplo
class Barber(BaseModel):
    name: str
    service: str

@app.get("/")
def read_root():
    return {"message": "Bienvenido a la API de Barberías hola"}

@app.get("/barbers", response_model=List[Barber])
def get_barbers():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT name, service FROM barbers")
    result = cursor.fetchall()
    conn.close()
    return [{"name": row[0], "service": row[1]} for row in result]
