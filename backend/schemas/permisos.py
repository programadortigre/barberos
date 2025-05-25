from datetime import datetime
from pydantic import BaseModel, Field

class PermisoBase(BaseModel):
    nombre: str = Field(..., max_length=100)
    clave: str = Field(..., max_length=100)
    descripcion: str | None = None

class PermisoCreate(PermisoBase):
    pass

class PermisoRead(PermisoBase):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True
