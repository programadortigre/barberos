from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from database import SessionLocal
from schemas.usuarios import UsuarioCreate, UsuarioRead, UsuarioUpdate
from crud import usuarios as crud_usuarios
from auth.dependencies import get_current_user
from models.usuarios import Usuario

router = APIRouter(prefix="/usuarios", tags=["Usuarios"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/me", response_model=UsuarioRead)
def read_me(current_user: Usuario = Depends(get_current_user)):
    return current_user

@router.post("/", response_model=UsuarioRead, status_code=status.HTTP_201_CREATED)
def crear_usuario(usuario: UsuarioCreate, db: Session = Depends(get_db)):
    db_usuario = crud_usuarios.get_usuario_por_username(db, usuario.username)
    if db_usuario:
        raise HTTPException(status_code=400, detail="Username ya existe")
    return crud_usuarios.crear_usuario(db, usuario)

@router.get("/{usuario_id}", response_model=UsuarioRead)
def leer_usuario(usuario_id: int, db: Session = Depends(get_db)):
    db_usuario = crud_usuarios.get_usuario_por_id(db, usuario_id)
    if not db_usuario:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    return db_usuario

@router.put("/{usuario_id}", response_model=UsuarioRead)
def actualizar_usuario(usuario_id: int, usuario_update: UsuarioUpdate, db: Session = Depends(get_db)):
    usuario_actualizado = crud_usuarios.actualizar_usuario(db, usuario_id, usuario_update)
    if not usuario_actualizado:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    return usuario_actualizado

@router.delete("/{usuario_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_usuario(usuario_id: int, db: Session = Depends(get_db)):
    usuario_eliminado = crud_usuarios.eliminar_usuario(db, usuario_id)
    if not usuario_eliminado:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    return None

@router.get("/", response_model=List[UsuarioRead])
def listar_usuarios(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    usuarios = crud_usuarios.listar_usuarios(db, skip=skip, limit=limit)
    return usuarios
