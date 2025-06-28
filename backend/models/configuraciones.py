from sqlalchemy import Column, String, Text, Enum, Integer, DateTime, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base
import enum

class TipoConfigEnum(enum.Enum):
    string = "string"
    int = "int"
    bool = "bool"
    json = "json"

class Configuracion(Base):
    __tablename__ = "configuraciones"

    clave = Column(String(100), primary_key=True)
    valor = Column(Text, nullable=False)
    descripcion = Column(Text, nullable=True)
    tipo = Column(Enum(TipoConfigEnum), nullable=False, server_default="string")
    creado_por = Column(Integer, ForeignKey("usuarios.id"), nullable=True)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())

    creador = relationship("Usuario")
