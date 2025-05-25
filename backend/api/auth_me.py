# api/auth_me.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from dependencies.auth import get_current_user
from schemas.usuario import UsuarioResponse  # este es tu esquema de respuesta

router = APIRouter(prefix="/auth", tags=["Autenticación"])

@router.get("/me", response_model=UsuarioResponse)
def obtener_usuario_actual(
    db: Session = Depends(get_db),
    usuario_actual=Depends(get_current_user)
):
    return usuario_actual
