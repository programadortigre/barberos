from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from database import get_db
from models.logs_usuarios import LogUsuario
from schemas.logs_usuarios import LogUsuarioCreate, LogUsuarioRead

router = APIRouter(prefix="/logs_usuarios", tags=["logs_usuarios"])

@router.post("/", response_model=LogUsuarioRead, status_code=status.HTTP_201_CREATED)
def crear_log(log: LogUsuarioCreate, db: Session = Depends(get_db)):
    nuevo_log = LogUsuario(**log.dict())
    db.add(nuevo_log)
    db.commit()
    db.refresh(nuevo_log)
    return nuevo_log

@router.get("/", response_model=List[LogUsuarioRead])
def listar_logs(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    logs = db.query(LogUsuario).offset(skip).limit(limit).all()
    return logs

@router.get("/{log_id}", response_model=LogUsuarioRead)
def obtener_log(log_id: int, db: Session = Depends(get_db)):
    log = db.query(LogUsuario).filter(LogUsuario.id == log_id).first()
    if not log:
        raise HTTPException(status_code=404, detail="Log no encontrado")
    return log

@router.delete("/{log_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_log(log_id: int, db: Session = Depends(get_db)):
    log = db.query(LogUsuario).filter(LogUsuario.id == log_id).first()
    if not log:
        raise HTTPException(status_code=404, detail="Log no encontrado")
    db.delete(log)
    db.commit()
    return
