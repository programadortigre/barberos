# schemas/perfiles.py
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class PerfilBase(BaseModel):
    persona_id: int
    tipo_perfil_id: int
    datos_personalizados_json: Optional[str] = None

class PerfilCreate(PerfilBase):
    pass

class PerfilUpdate(PerfilBase):
    pass

class PerfilRead(PerfilBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
