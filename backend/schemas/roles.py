# schemas/roles.py
from datetime import datetime
from pydantic import BaseModel
from typing import Optional, List

class RolBase(BaseModel):
    nombre: str
    descripcion: Optional[str] = None

class RolCreate(RolBase):
    pass

class RolRead(RolBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
