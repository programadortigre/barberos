from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class RolPermisoBase(BaseModel):
    rol_id: int
    permiso_id: int
    creado_por: Optional[int] = None

class RolPermisoCreate(RolPermisoBase):
    pass

class RolPermisoRead(RolPermisoBase):
    created_at: datetime

    class Config:
        orm_mode = True
