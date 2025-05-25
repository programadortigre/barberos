from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    DateTime,
    ForeignKey,
    Enum,
    CHAR,
    LargeBinary,
    Boolean,
    UniqueConstraint,
    BigInteger,
    Index,
    JSON,
)
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from database import Base
import enum
import uuid


class EstadoUsuarioEnum(enum.Enum):
    activo = "activo"
    suspendido = "suspendido"
    eliminado = "eliminado"


class TipoTokenEnum(enum.Enum):
    access = "access"
    refresh = "refresh"
    api = "api"


class TipoConfigEnum(enum.Enum):
    string = "string"
    int = "int"
    bool = "bool"
    json = "json"


# --- Modelos para MySQL 8.0 ---


class Persona(Base):
    __tablename__ = "personas"

    id = Column(Integer, primary_key=True, autoincrement=True)
    tipo_documento = Column(String(20), nullable=False, index=True)
    dni = Column(String(15), nullable=False, unique=True, index=True)
    nombres = Column(String(100), nullable=False)
    apellido_paterno = Column(String(100), nullable=False)
    apellido_materno = Column(String(100), nullable=True)
    fecha_nacimiento = Column(DateTime, nullable=False)
    genero = Column(
        CHAR(1),
        nullable=False,
        server_default="O",
        comment="M: Masculino, F: Femenino, O: Otro",
    )
    direccion_cifrada = Column(
        LargeBinary(length=4294967295), nullable=True
    )  # LONGBLOB
    telefono_cifrado = Column(LargeBinary(length=65535), nullable=True)  # BLOB
    correo_cifrado = Column(LargeBinary(length=65535), nullable=True)
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    updated_at = Column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp(),
    )

    usuario = relationship(
        "Usuario", back_populates="persona", uselist=False, cascade="all, delete-orphan"
    )
    perfiles = relationship(
        "Perfil", back_populates="persona", cascade="all, delete-orphan"
    )

    __table_args__ = (
        Index("idx_persona_nombres", "nombres"),
        Index("idx_persona_apellidos", "apellido_paterno", "apellido_materno"),
    )


class Rol(Base):
    __tablename__ = "roles"

    id = Column(Integer, primary_key=True, autoincrement=True)
    nombre = Column(String(50), nullable=False, unique=True, index=True)
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

    usuarios = relationship("Usuario", back_populates="rol")
    roles_permisos = relationship(
        "RolPermiso", back_populates="rol", cascade="all, delete-orphan"
    )
    permisos = relationship(
        "Permiso", secondary="roles_permisos", back_populates="roles"
    )


class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, autoincrement=True)
    persona_id = Column(
        Integer,
        ForeignKey("personas.id", ondelete="CASCADE"),
        nullable=False,
        unique=True,
        index=True,
    )
    username = Column(String(50), nullable=False, unique=True, index=True)
    password_hash = Column(String(255), nullable=False)
    rol_id = Column(Integer, ForeignKey("roles.id"), nullable=False, index=True)
    estado = Column(
        Enum(EstadoUsuarioEnum, values_callable=lambda x: [e.value for e in x]),
        default=EstadoUsuarioEnum.activo,
    )
    ultimo_login = Column(DateTime, nullable=True)
    intentos_fallidos = Column(Integer, default=0)
    api_key_hash = Column(String(255), nullable=True)
    api_key_expira = Column(DateTime, nullable=True)
    creado_por = Column(Integer, ForeignKey("usuarios.id"), nullable=True, index=True)
    modificado_por = Column(
        Integer, ForeignKey("usuarios.id"), nullable=True, index=True
    )
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    updated_at = Column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp(),
    )

    persona = relationship("Persona", back_populates="usuario")
    rol = relationship("Rol", back_populates="usuarios")
    creador = relationship("Usuario", remote_side=[id], foreign_keys=[creado_por])
    modificador = relationship(
        "Usuario", remote_side=[id], foreign_keys=[modificado_por]
    )
    tokens = relationship(
        "Token", back_populates="usuario", cascade="all, delete-orphan"
    )
    logs_usuarios = relationship(
        "LogUsuario", back_populates="usuario", cascade="all, delete-orphan"
    )
    roles_permisos_creados = relationship("RolPermiso", back_populates="creador")
    configuraciones_creadas = relationship("Configuracion", back_populates="creador")


class Permiso(Base):
    __tablename__ = "permisos"

    id = Column(Integer, primary_key=True, autoincrement=True)
    nombre = Column(String(100), nullable=False, unique=True, index=True)
    clave = Column(String(100), nullable=False, unique=True, index=True)
    descripcion = Column(Text, nullable=True)
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )

    roles_permisos = relationship("RolPermiso", back_populates="permiso")
    roles = relationship("Rol", secondary="roles_permisos", back_populates="permisos")


class RolPermiso(Base):
    __tablename__ = "roles_permisos"

    rol_id = Column(
        Integer,
        ForeignKey("roles.id", ondelete="CASCADE"),
        primary_key=True,
        nullable=False,
    )
    permiso_id = Column(
        Integer,
        ForeignKey("permisos.id", ondelete="CASCADE"),
        primary_key=True,
        nullable=False,
    )
    creado_por = Column(
        Integer, ForeignKey("usuarios.id", ondelete="SET NULL"), nullable=True
    )
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )

    rol = relationship("Rol", back_populates="roles_permisos")
    permiso = relationship("Permiso", back_populates="roles_permisos")
    creador = relationship("Usuario", back_populates="roles_permisos_creados")


class LogUsuario(Base):
    __tablename__ = "logs_usuarios"
    __table_args__ = (
        Index("idx_logs_usuario_accion", "accion"),
        Index("idx_logs_usuario_fecha", "created_at"),
    )

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False, index=True)
    accion = Column(String(255), nullable=False)
    tabla_afectada = Column(String(100), nullable=True)
    registro_id = Column(Integer, nullable=True)
    descripcion = Column(Text, nullable=True)
    ip_address = Column(String(45), nullable=True)
    detalles_json = Column(JSON, nullable=True)  # JSON para MySQL 8.0+
    user_agent = Column(String(255), nullable=True)
    navegador = Column(String(100), nullable=True)
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )

    usuario = relationship("Usuario", back_populates="logs_usuarios")


class Token(Base):
    __tablename__ = "tokens"
    __table_args__ = (
        Index("idx_token_expiracion", "expiracion"),
        Index("idx_token_usuario", "usuario_id"),
    )

    token = Column(
        CHAR(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )  # CHAR para UUID
    usuario_id = Column(
        Integer, ForeignKey("usuarios.id", ondelete="CASCADE"), nullable=False
    )
    tipo_token = Column(
        Enum(TipoTokenEnum, values_callable=lambda x: [e.value for e in x]),
        nullable=True,
    )
    expiracion = Column(DateTime, nullable=False)
    revocado = Column(Boolean, nullable=False, default=False, index=True)
    revocado_at = Column(DateTime, nullable=True)
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )

    usuario = relationship("Usuario", back_populates="tokens")


class TipoPerfil(Base):
    __tablename__ = "tipos_perfil"

    id = Column(Integer, primary_key=True, autoincrement=True)
    clave = Column(String(50), nullable=False, unique=True, index=True)
    nombre = Column(String(100), nullable=False)
    descripcion = Column(Text, nullable=True)
    campos_json = Column(JSON, nullable=True)  # JSON para MySQL 8.0+
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    updated_at = Column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp(),
    )

    perfiles = relationship("Perfil", back_populates="tipo_perfil")


class Perfil(Base):
    __tablename__ = "perfiles"
    __table_args__ = (
        UniqueConstraint(
            "persona_id", "tipo_perfil_id", name="ux_perfiles_persona_tipo"
        ),
        Index("idx_perfil_tipo", "tipo_perfil_id"),
    )

    id = Column(Integer, primary_key=True, autoincrement=True)
    persona_id = Column(
        Integer,
        ForeignKey("personas.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    tipo_perfil_id = Column(Integer, ForeignKey("tipos_perfil.id"), nullable=False)
    datos_personalizados_json = Column(JSON, nullable=True)
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    updated_at = Column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp(),
    )

    persona = relationship("Persona", back_populates="perfiles")
    tipo_perfil = relationship("TipoPerfil", back_populates="perfiles")


class Configuracion(Base):
    __tablename__ = "configuraciones"
    __table_args__ = (Index("idx_config_tipo", "tipo"),)

    clave = Column(String(100), primary_key=True)
    valor = Column(Text, nullable=False)
    descripcion = Column(Text, nullable=True)
    tipo = Column(
        Enum(TipoConfigEnum, values_callable=lambda x: [e.value for e in x]),
        nullable=False,
        server_default="string",
    )
    creado_por = Column(
        Integer,
        ForeignKey("usuarios.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )
    created_at = Column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )

    creador = relationship("Usuario", back_populates="configuraciones_creadas")
