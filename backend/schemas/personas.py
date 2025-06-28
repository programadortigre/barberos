from pydantic import BaseModel, constr
from typing import Optional
from datetime import date, datetime

class PersonaBase(BaseModel):
    tipo_documento: constr(max_length=20)
    dni: constr(max_length=15)
    nombres: constr(max_length=100)
    apellido_paterno: constr(max_length=100)
    apellido_materno: Optional[constr(max_length=100)] = None
    fecha_nacimiento: date
    genero: Optional[str] = 'O'

class PersonaCreate(PersonaBase):
    direccion_cifrada: Optional[bytes] = None
    telefono_cifrado: Optional[bytes] = None
    correo_cifrado: Optional[bytes] = None

class PersonaRead(PersonaBase):
    id: int
    direccion_cifrada: Optional[bytes] = None
    telefono_cifrado: Optional[bytes] = None
    correo_cifrado: Optional[bytes] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
