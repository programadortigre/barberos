from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship

from database import Base


class Rol(Base):
    __tablename__ = "roles"

    id = Column(Integer, primary_key=True, autoincrement=True)
    nombre = Column(String(50), nullable=False, unique=True)
    descripcion = Column(Text, nullable=True)
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    updated_at = Column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp(),
    )
    # Relaciones opcionales para facilitar consultas
    roles_permisos = relationship("RolPermiso", back_populates="rol")
    usuarios = relationship("Usuario", back_populates="rol")
    permisos = relationship(
        "Permiso", secondary="roles_permisos", back_populates="roles"
    )
