import os
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session

from database import get_db
from schemas.auth import LoginRequest, TokenResponse
from auth.auth import login_user

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

ENV = os.getenv("ENV", "development")

app = FastAPI(
    title="Barbería API",
    docs_url=None if ENV == "production" else "/docs",
    redoc_url=None if ENV == "production" else "/redoc",
    openapi_url=None if ENV == "production" else "/openapi.json",
)

# Leer CORS desde entorno
raw_origins = os.environ.get("CORS_ORIGINS", "")
origins = [origin.strip() for origin in raw_origins.split(",") if origin.strip()]
print(f"🌐 Orígenes CORS permitidos: {origins}")

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.post("/login", response_model=TokenResponse)
def login(data: LoginRequest, db: Session = Depends(get_db)):
    return login_user(data, db)


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
    auth_router.router,
]

for router in routers:
    app.include_router(router)


@app.get("/")
def root():
    return {"message": "API corriendo correctamente 🚀"}
