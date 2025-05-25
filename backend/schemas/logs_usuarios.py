from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class LogUsuarioBase(BaseModel):
    usuario_id: int
    accion: str
    tabla_afectada: Optional[str] = None
    registro_id: Optional[int] = None
    descripcion: Optional[str] = None
    ip_address: Optional[str] = None
    detalles_json: Optional[str] = None
    user_agent: Optional[str] = None
    navegador: Optional[str] = None

class LogUsuarioCreate(LogUsuarioBase):
    pass

class LogUsuarioRead(LogUsuarioBase):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True
