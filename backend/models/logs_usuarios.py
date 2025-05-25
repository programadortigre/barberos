from sqlalchemy import Column, BigInteger, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base


class LogUsuario(Base):
    __tablename__ = "logs_usuarios"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    accion = Column(String(255), nullable=False)
    tabla_afectada = Column(String(100), nullable=True)
    registro_id = Column(Integer, nullable=True)
    descripcion = Column(Text, nullable=True)
    ip_address = Column(String(45), nullable=True)
    detalles_json = Column(Text, nullable=True)
    user_agent = Column(String(255), nullable=True)
    navegador = Column(String(100), nullable=True)
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )

    usuario = relationship("Usuario", back_populates="logs_usuarios")

    __table_args__ = (Index("idx_usuario_created_at", "usuario_id", "created_at"),)
