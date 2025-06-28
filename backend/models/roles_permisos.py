from sqlalchemy import Column, Integer, DateTime, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base

class RolPermiso(Base):
    __tablename__ = "roles_permisos"

    rol_id = Column(Integer, ForeignKey("roles.id"), primary_key=True, nullable=False)
    permiso_id = Column(Integer, ForeignKey("permisos.id"), primary_key=True, nullable=False)
    creado_por = Column(Integer, ForeignKey("usuarios.id"), nullable=True)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())

    # Opcionalmente puedes definir relaciones para facilitar acceso a objetos relacionados
    rol = relationship("Rol", back_populates="roles_permisos")
    permiso = relationship("Permiso", back_populates="roles_permisos")
    creador = relationship("Usuario")
