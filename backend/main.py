from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session

from database import get_db
from schemas.auth import LoginRequest, TokenResponse
from auth.auth import login_user

# importar routers
from api import (
    usuarios,
    roles,
    personas,
    permisos,
    roles_permisos,
    logs_usuarios,
    tokens,
    tipos_perfil,
    perfiles,
    configuraciones,
    auth_router,
)

app = FastAPI()

# CORS: permitir solo tu frontend (ajusta el dominio en producción)
origins = [
    "http://localhost:3000",  # Nuxt local
    "http://127.0.0.1:3000",  # otra variante local
    "https://tudominio.com",  # tu dominio real en producción
    "http://192.168.0.104:3000/",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],  # puedes restringir por seguridad
    allow_headers=["*"],
)


# Login
@app.post("/login", response_model=TokenResponse)
def login(data: LoginRequest, db: Session = Depends(get_db)):
    return login_user(data, db)


# registrar routers
routers = [
    usuarios.router,
    roles.router,
    personas.router,
    permisos.router,
    roles_permisos.router,
    logs_usuarios.router,
    tokens.router,
    tipos_perfil.router,
    perfiles.router,
    configuraciones.router,
]

for router in routers:
    app.include_router(router)


@app.get("/")
def root():
    return {"message": "API corriendo correctamente 🚀"}
