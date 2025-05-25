from typing import Optional, List, Dict, Any
from datetime import datetime
from pydantic import BaseModel, constr, Field, validator
from enum import Enum


# --- Enums ---
class EstadoUsuarioEnum(str, Enum):
    activo = "activo"
    suspendido = "suspendido"
    eliminado = "eliminado"


class TipoTokenEnum(str, Enum):
    access = "access"
    refresh = "refresh"
    api = "api"


class TipoConfigEnum(str, Enum):
    string = "string"
    int = "int"
    bool = "bool"
    json = "json"


# --- Personas ---
class PersonaBase(BaseModel):
    tipo_documento: constr(strip_whitespace=True, max_length=20) = Field(
        ..., example="DNI"
    )
    dni: constr(strip_whitespace=True, max_length=15) = Field(..., example="12345678")
    nombres: constr(strip_whitespace=True, max_length=100) = Field(
        ..., example="Juan Carlos"
    )
    apellido_paterno: constr(strip_whitespace=True, max_length=100) = Field(
        ..., example="Perez"
    )
    apellido_materno: Optional[constr(strip_whitespace=True, max_length=100)] = Field(
        None, example="Lopez"
    )
    fecha_nacimiento: datetime = Field(..., example="1990-01-01T00:00:00")
    genero: constr(min_length=1, max_length=1) = Field(
        ..., example="M", description="M: Masculino, F: Femenino, O: Otro"
    )

    @validator("genero")
    def validar_genero(cls, v):
        if v.upper() not in ("M", "F", "O"):
            raise ValueError("Género debe ser M, F u O")
        return v.upper()


class PersonaCreate(PersonaBase):
    pass


class PersonaUpdate(BaseModel):
    tipo_documento: Optional[constr(max_length=20)]
    dni: Optional[constr(max_length=15)]
    nombres: Optional[constr(max_length=100)]
    apellido_paterno: Optional[constr(max_length=100)]
    apellido_materno: Optional[constr(max_length=100)]
    fecha_nacimiento: Optional[datetime]
    genero: Optional[constr(min_length=1, max_length=1)]

    @validator("genero")
    def validar_genero(cls, v):
        if v and v.upper() not in ("M", "F", "O"):
            raise ValueError("Género debe ser M, F u O")
        return v.upper() if v else v


class PersonaRead(PersonaBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True


# --- Roles ---
class RolBase(BaseModel):
    nombre: constr(strip_whitespace=True, max_length=50) = Field(
        ..., example="Administrador"
    )
    descripcion: Optional[str] = Field(None, example="Rol con todos los permisos")


class RolCreate(RolBase):
    pass


class RolUpdate(BaseModel):
    nombre: Optional[constr(max_length=50)]
    descripcion: Optional[str]


class RolRead(RolBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True


# --- Permisos ---
class PermisoBase(BaseModel):
    nombre: constr(strip_whitespace=True, max_length=100) = Field(
        ..., example="Crear Usuario"
    )
    clave: constr(strip_whitespace=True, max_length=100) = Field(
        ..., example="crear_usuario"
    )
    descripcion: Optional[str] = Field(None, example="Permiso para crear usuarios")


class PermisoCreate(PermisoBase):
    pass


class PermisoUpdate(BaseModel):
    nombre: Optional[constr(max_length=100)]
    clave: Optional[constr(max_length=100)]
    descripcion: Optional[str]


class PermisoRead(PermisoBase):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True


# --- RolesPermisos ---
class RolPermisoBase(BaseModel):
    rol_id: int = Field(..., example=1)
    permiso_id: int = Field(..., example=2)
    creado_por: Optional[int] = Field(None, example=1)


class RolPermisoCreate(RolPermisoBase):
    pass


class RolPermisoRead(RolPermisoBase):
    created_at: datetime

    class Config:
        orm_mode = True


# --- Usuarios ---
class UsuarioBase(BaseModel):
    persona_id: int = Field(..., example=1)
    username: constr(strip_whitespace=True, max_length=50) = Field(
        ..., example="juan.perez"
    )
    rol_id: int = Field(..., example=1)
    estado: EstadoUsuarioEnum = Field(default=EstadoUsuarioEnum.activo)


class UsuarioCreate(UsuarioBase):
    password: constr(min_length=8, max_length=128) = Field(..., example="Password123!")

    @validator("password")
    def validar_password(cls, v):
        import re

        if len(v) < 8:
            raise ValueError("La contraseña debe tener al menos 8 caracteres")
        if not re.search(r"\d", v):
            raise ValueError("Debe contener al menos un número")
        if not re.search(r"[A-Z]", v):
            raise ValueError("Debe contener al menos una mayúscula")
        return v


class UsuarioUpdate(BaseModel):
    username: Optional[constr(max_length=50)]
    rol_id: Optional[int]
    estado: Optional[EstadoUsuarioEnum]
    password: Optional[constr(min_length=8, max_length=128)]

    @validator("password")
    def validar_password(cls, v):
        if v is None:
            return v
        import re

        if len(v) < 8:
            raise ValueError("La contraseña debe tener al menos 8 caracteres")
        if not re.search(r"\d", v):
            raise ValueError("Debe contener al menos un número")
        if not re.search(r"[A-Z]", v):
            raise ValueError("Debe contener al menos una mayúscula")
        return v


class UsuarioRead(UsuarioBase):
    id: int
    ultimo_login: Optional[datetime]
    intentos_fallidos: int = 0
    creado_por: Optional[int]
    modificado_por: Optional[int]
    created_at: datetime
    updated_at: datetime
    persona: Optional[PersonaRead]

    class Config:
        orm_mode = True


# --- Tokens ---
class TokenBase(BaseModel):
    usuario_id: int
    tipo_token: Optional[TipoTokenEnum] = None
    expiracion: datetime
    revocado: bool = False


class TokenCreate(TokenBase):
    token: Optional[constr(min_length=36, max_length=36)] = None


class TokenRead(TokenBase):
    token: str
    revocado_at: Optional[datetime]
    created_at: datetime

    class Config:
        orm_mode = True


# --- Configuraciones ---
class ConfiguracionBase(BaseModel):
    clave: constr(strip_whitespace=True, max_length=100) = Field(
        ..., example="MAX_LOGIN_ATTEMPTS"
    )
    valor: str = Field(..., example="3")
    descripcion: Optional[str] = None
    tipo: TipoConfigEnum = TipoConfigEnum.string


class ConfiguracionCreate(ConfiguracionBase):
    pass


class ConfiguracionUpdate(BaseModel):
    valor: Optional[str]
    descripcion: Optional[str]
    tipo: Optional[TipoConfigEnum]


class ConfiguracionRead(ConfiguracionBase):
    creado_por: Optional[int]
    created_at: datetime

    class Config:
        orm_mode = True


# --- Perfiles ---
class PerfilBase(BaseModel):
    persona_id: int
    tipo_perfil_id: int
    datos_personalizados_json: Optional[Dict[str, Any]] = None


class PerfilCreate(PerfilBase):
    pass


class PerfilUpdate(BaseModel):
    datos_personalizados_json: Optional[Dict[str, Any]]


class PerfilRead(PerfilBase):
    id: int
    created_at: datetime
    updated_at: datetime
    tipo_perfil: Optional[TipoPerfilRead]

    class Config:
        orm_mode = True


# --- Autenticación ---
class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class LoginRequest(BaseModel):
    username: str
    password: str


class RefreshTokenRequest(BaseModel):
    refresh_token: str
