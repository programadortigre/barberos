from sqlalchemy import Column, Integer, ForeignKey, Text, DateTime, UniqueConstraint
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base

class Perfil(Base):
    __tablename__ = "perfiles"
    __table_args__ = (
        UniqueConstraint('persona_id', 'tipo_perfil_id', name='ux_perfiles_persona_tipo'),
    )

    id = Column(Integer, primary_key=True, autoincrement=True)
    persona_id = Column(Integer, ForeignKey("personas.id"), nullable=False)
    tipo_perfil_id = Column(Integer, ForeignKey("tipos_perfil.id"), nullable=False)
    datos_personalizados_json = Column(Text, nullable=True)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())
    updated_at = Column(DateTime, nullable=False, server_default=func.current_timestamp(), onupdate=func.current_timestamp())

    # Relaciones para facilitar consultas
    persona = relationship("Persona", back_populates="perfiles")
    tipo_perfil = relationship("TipoPerfil", back_populates="perfiles")
