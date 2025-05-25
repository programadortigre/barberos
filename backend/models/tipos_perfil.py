from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship

from database import Base

class TipoPerfil(Base):
    __tablename__ = "tipos_perfil"

    id = Column(Integer, primary_key=True, autoincrement=True)
    clave = Column(String(50), nullable=False, unique=True)
    nombre = Column(String(100), nullable=False)
    descripcion = Column(Text, nullable=True)
    campos_json = Column(Text, nullable=True)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())
    updated_at = Column(DateTime, nullable=False, server_default=func.current_timestamp(), onupdate=func.current_timestamp())
#     # Relaciones opcionales para facilitar consultas
    perfiles = relationship("Perfil", back_populates="tipo_perfil")