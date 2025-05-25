from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base

class Permiso(Base):
    __tablename__ = "permisos"

    id = Column(Integer, primary_key=True, autoincrement=True)
    nombre = Column(String(100), nullable=False, unique=True)
    clave = Column(String(100), nullable=False, unique=True)
    descripcion = Column(Text, nullable=True)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())

    # Relaciones
    roles_permisos = relationship("RolPermiso", back_populates="permiso")

    # 🚀 Esta relación es la clave para que rol.permisos funcione correctamente
    roles = relationship(
        "Rol",
        secondary="roles_permisos",
        back_populates="permisos"
    )
