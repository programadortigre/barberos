# api/auth_router.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from auth.dependencies import get_current_user
from models.usuarios import Usuario
from schemas.usuarios import UsuarioRead
from schemas.auth import LoginRequest, TokenResponse
from auth.auth import login_user
from database import get_db

router = APIRouter(tags=["Autenticación"])

@router.post("/login", response_model=TokenResponse)
def login(data: LoginRequest, db: Session = Depends(get_db)):
    return login_user(data, db)

@router.get("/me", response_model=UsuarioRead)
def read_me(current_user: Usuario = Depends(get_current_user)):
    return current_user
