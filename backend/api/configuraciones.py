from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models.configuraciones import Configuracion
from schemas.configuraciones import ConfiguracionCreate, ConfiguracionRead, ConfiguracionUpdate

router = APIRouter(prefix="/configuraciones", tags=["configuraciones"])

@router.get("/", response_model=list[ConfiguracionRead])
def listar_configuraciones(db: Session = Depends(get_db)):
    return db.query(Configuracion).all()

@router.get("/{clave}", response_model=ConfiguracionRead)
def obtener_configuracion(clave: str, db: Session = Depends(get_db)):
    c = db.query(Configuracion).filter(Configuracion.clave == clave).first()
    if not c:
        raise HTTPException(status_code=404, detail="Configuración no encontrada")
    return c

@router.post("/", response_model=ConfiguracionRead)
def crear_configuracion(conf: ConfiguracionCreate, db: Session = Depends(get_db)):
    existe = db.query(Configuracion).filter(Configuracion.clave == conf.clave).first()
    if existe:
        raise HTTPException(status_code=400, detail="La clave ya existe")
    nuevo = Configuracion(**conf.dict())
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

@router.put("/{clave}", response_model=ConfiguracionRead)
def actualizar_configuracion(clave: str, conf: ConfiguracionUpdate, db: Session = Depends(get_db)):
    c = db.query(Configuracion).filter(Configuracion.clave == clave).first()
    if not c:
        raise HTTPException(status_code=404, detail="Configuración no encontrada")
    for k, v in conf.dict(exclude_unset=True).items():
        setattr(c, k, v)
    db.commit()
    db.refresh(c)
    return c

@router.delete("/{clave}")
def eliminar_configuracion(clave: str, db: Session = Depends(get_db)):
    c = db.query(Configuracion).filter(Configuracion.clave == clave).first()
    if not c:
        raise HTTPException(status_code=404, detail="Configuración no encontrada")
    db.delete(c)
    db.commit()
    return {"detail": "Configuración eliminada"}
