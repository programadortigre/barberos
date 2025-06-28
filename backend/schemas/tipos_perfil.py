# schemas/tipos_perfil.py
from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class TipoPerfilBase(BaseModel):
    clave: str = Field(..., max_length=50)
    nombre: str = Field(..., max_length=100)
    descripcion: Optional[str] = None
    campos_json: Optional[str] = None

class TipoPerfilCreate(TipoPerfilBase):
    pass

class TipoPerfilUpdate(TipoPerfilBase):
    pass

class TipoPerfilRead(TipoPerfilBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
