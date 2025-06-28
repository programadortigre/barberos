from sqlalchemy import Column, String, Integer, Enum, DateTime, Boolean, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base
import enum

class TipoTokenEnum(enum.Enum):
    access = "access"
    refresh = "refresh"
    api = "api"

class Token(Base):
    __tablename__ = "tokens"

    token = Column(String(36), primary_key=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    tipo_token = Column(Enum(TipoTokenEnum), nullable=True)
    expiracion = Column(DateTime, nullable=False)
    revocado = Column(Boolean, nullable=False, default=False)
    revocado_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())

    usuario = relationship("Usuario", back_populates="tokens")
