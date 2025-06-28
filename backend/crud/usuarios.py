from sqlalchemy.orm import Session
from models.usuarios import Usuario
from core.security import get_password_hash, verify_password
from schemas.usuarios import UsuarioCreate, UsuarioUpdate
from datetime import datetime

def get_usuario_por_id(db: Session, usuario_id: int):
    return db.query(Usuario).filter(Usuario.id == usuario_id).first()

def get_usuario_por_username(db: Session, username: str):
    return db.query(Usuario).filter(Usuario.username == username).first()

def crear_usuario(db: Session, usuario: UsuarioCreate):
    db_usuario = Usuario(
        username=usuario.username,
        password_hash=get_password_hash(usuario.password),
        persona_id=usuario.persona_id,
        rol_id=usuario.rol_id,
        estado=usuario.estado
    )
    db.add(db_usuario)
    db.commit()
    db.refresh(db_usuario)
    return db_usuario

def actualizar_usuario(db: Session, usuario_id: int, usuario_update: UsuarioUpdate):
    usuario_db = get_usuario_por_id(db, usuario_id)
    if not usuario_db:
        return None

    if usuario_update.username is not None:
        usuario_db.username = usuario_update.username

    if usuario_update.password is not None and usuario_update.password != "":
        usuario_db.password_hash = get_password_hash(usuario_update.password)

    if usuario_update.estado is not None:
        usuario_db.estado = usuario_update.estado

    if usuario_update.rol_id is not None:
        usuario_db.rol_id = usuario_update.rol_id

    usuario_db.updated_at = datetime.utcnow()

    db.commit()
    db.refresh(usuario_db)
    return usuario_db


def eliminar_usuario(db: Session, usuario_id: int):
    usuario_db = get_usuario_por_id(db, usuario_id)
    if not usuario_db:
        return None
    db.delete(usuario_db)
    db.commit()
    return usuario_db

def listar_usuarios(db: Session, skip: int = 0, limit: int = 100):
    return db.query(Usuario).offset(skip).limit(limit).all()
