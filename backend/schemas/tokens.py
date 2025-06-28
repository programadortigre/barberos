from pydantic import BaseModel
from datetime import datetime
from typing import Optional
import enum

class TipoTokenEnum(str, enum.Enum):
    access = "access"
    refresh = "refresh"
    api = "api"

class TokenBase(BaseModel):
    usuario_id: int
    tipo_token: Optional[TipoTokenEnum] = None
    expiracion: datetime
    revocado: bool = False

class TokenCreate(TokenBase):
    token: str  # el valor del token al crearlo

class TokenRead(TokenBase):
    token: str
    revocado_at: Optional[datetime] = None
    created_at: datetime

    class Config:
        orm_mode = True

class TokenUpdateRevocado(BaseModel):
    revocado: bool
    revocado_at: Optional[datetime] = None
