from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from database import get_db
from models.roles_permisos import RolPermiso
from schemas.roles_permisos import RolPermisoCreate, RolPermisoRead

router = APIRouter(prefix="/roles_permisos", tags=["roles_permisos"])

@router.post("/", response_model=RolPermisoRead, status_code=status.HTTP_201_CREATED)
def create_rol_permiso(data: RolPermisoCreate, db: Session = Depends(get_db)):
    # Verificar si la relación ya existe para evitar duplicados
    existing = db.query(RolPermiso).filter(
        RolPermiso.rol_id == data.rol_id,
        RolPermiso.permiso_id == data.permiso_id
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="La relación rol-permiso ya existe")

    nuevo = RolPermiso(**data.dict())
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return nuevo

@router.get("/", response_model=List[RolPermisoRead])
def listar_roles_permisos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return db.query(RolPermiso).offset(skip).limit(limit).all()

@router.get("/{rol_id}/{permiso_id}", response_model=RolPermisoRead)
def obtener_rol_permiso(rol_id: int, permiso_id: int, db: Session = Depends(get_db)):
    obj = db.query(RolPermiso).filter(
        RolPermiso.rol_id == rol_id,
        RolPermiso.permiso_id == permiso_id
    ).first()
    if not obj:
        raise HTTPException(status_code=404, detail="Relación no encontrada")
    return obj

@router.delete("/{rol_id}/{permiso_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_rol_permiso(rol_id: int, permiso_id: int, db: Session = Depends(get_db)):
    obj = db.query(RolPermiso).filter(
        RolPermiso.rol_id == rol_id,
        RolPermiso.permiso_id == permiso_id
    ).first()
    if not obj:
        raise HTTPException(status_code=404, detail="Relación no encontrada")
    db.delete(obj)
    db.commit()
    return

# Opcional: actualizar el campo creado_por (si quieres permitir update)
@router.put("/{rol_id}/{permiso_id}", response_model=RolPermisoRead)
def actualizar_rol_permiso(rol_id: int, permiso_id: int, data: RolPermisoCreate, db: Session = Depends(get_db)):
    obj = db.query(RolPermiso).filter(
        RolPermiso.rol_id == rol_id,
        RolPermiso.permiso_id == permiso_id
    ).first()
    if not obj:
        raise HTTPException(status_code=404, detail="Relación no encontrada")

    obj.creado_por = data.creado_por
    db.commit()
    db.refresh(obj)
    return obj
