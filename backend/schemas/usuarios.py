from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from enum import Enum
#from schemas.roles import RolRead  # Importamos el esquema rol
#from schemas.personas import PersonaRead  # Importamos el esquema persona


class EstadoUsuario(str, Enum):
    activo = "activo"
    suspendido = "suspendido"
    eliminado = "eliminado"

class UsuarioBase(BaseModel):
    username: str = Field(..., max_length=50)
    estado: Optional[EstadoUsuario] = EstadoUsuario.activo

class UsuarioCreate(UsuarioBase):
    password: str = Field(..., min_length=6)
    persona_id: int
    rol_id: int

class UsuarioRead(UsuarioBase):
    id: int
    persona_id: int
    rol_id: int
    ultimo_login: Optional[datetime] = None
    intentos_fallidos: Optional[int] = 0
    created_at: datetime
    updated_at: datetime
    #rol: Optional[RolRead]  # <-- Aquí agregamos el rol anidado
    #persona: Optional[PersonaRead]   # <-- Agrega persona anidada

    class Config:
        orm_mode = True

class UsuarioUpdate(BaseModel):
    username: Optional[str] = Field(None, max_length=50)
    estado: Optional[EstadoUsuario]
    password: Optional[str] = Field(None, min_length=6)
    rol_id: Optional[int]

