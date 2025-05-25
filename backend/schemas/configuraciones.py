# schemas/configuraciones.py
from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from enum import Enum

class TipoConfigEnum(str, Enum):
    string = "string"
    int = "int"
    bool = "bool"
    json = "json"

class ConfiguracionBase(BaseModel):
    valor: str
    descripcion: Optional[str] = None
    tipo: Optional[TipoConfigEnum] = TipoConfigEnum.string
    creado_por: Optional[int] = None

class ConfiguracionCreate(ConfiguracionBase):
    clave: str  # primaria, debe venir al crear

class ConfiguracionUpdate(ConfiguracionBase):
    pass

class ConfiguracionRead(ConfiguracionBase):
    clave: str
    created_at: datetime

    class Config:
        orm_mode = True
