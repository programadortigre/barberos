from sqlalchemy import (
    Column, Integer, String, Enum, DateTime, ForeignKey
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database import Base

class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, autoincrement=True)
    persona_id = Column(Integer, ForeignKey("personas.id"), nullable=False, unique=True)
    username = Column(String(50), nullable=False, unique=True)
    password_hash = Column(String(255), nullable=False)
    rol_id = Column(Integer, ForeignKey("roles.id"), nullable=False)
    estado = Column(Enum('activo', 'suspendido', 'eliminado', name="estado_usuario"), default='activo')
    ultimo_login = Column(DateTime, nullable=True)
    intentos_fallidos = Column(Integer, default=0)
    api_key_hash = Column(String(255), nullable=True)
    api_key_expira = Column(DateTime, nullable=True)
    creado_por = Column(Integer, ForeignKey("usuarios.id"), nullable=True)
    modificado_por = Column(Integer, ForeignKey("usuarios.id"), nullable=True)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())
    updated_at = Column(DateTime, nullable=False, server_default=func.current_timestamp(), onupdate=func.current_timestamp())

    # Relaciones opcionales para facilitar consultas
    persona = relationship("Persona", back_populates="usuario", uselist=False)
    rol = relationship("Rol", back_populates="usuarios")
    creador = relationship("Usuario", remote_side=[id], foreign_keys=[creado_por], post_update=True)
    modificador = relationship("Usuario", remote_side=[id], foreign_keys=[modificado_por], post_update=True)
    tokens = relationship("Token", back_populates="usuario")
    logs_usuarios = relationship("LogUsuario", back_populates="usuario")
