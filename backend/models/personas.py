from sqlalchemy import Column, Integer, String, Date, CHAR, LargeBinary, DateTime, Index, text
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base  # tu Base declarativa

class Persona(Base):
    __tablename__ = "personas"

    id = Column(Integer, primary_key=True, autoincrement=True)
    tipo_documento = Column(String(20), nullable=False)
    dni = Column(String(15), nullable=False, unique=True)
    nombres = Column(String(100), nullable=False)
    apellido_paterno = Column(String(100), nullable=False)
    apellido_materno = Column(String(100), nullable=True)
    fecha_nacimiento = Column(Date, nullable=False)
    genero = Column(CHAR(1), nullable=False, server_default='O', comment="M: Masculino, F: Femenino, O: Otro")
    direccion_cifrada = Column(LargeBinary(512), nullable=True)
    telefono_cifrado = Column(LargeBinary(128), nullable=True)
    correo_cifrado = Column(LargeBinary(256), nullable=True)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())
    updated_at = Column(DateTime, nullable=False, server_default=func.current_timestamp(), onupdate=func.current_timestamp())

    __table_args__ = (
        Index("idx_apellidos", "apellido_paterno", "apellido_materno"),
    )
    #relaciones opcionales para facilitar consultas
    usuario = relationship("Usuario", back_populates="persona", uselist=False)
    perfiles = relationship("Perfil", back_populates="persona")
