# routers/permisos.py
from fastapi_crudrouter import SQLAlchemyCRUDRouter
from models.permisos import Permiso
from schemas.permisos import PermisoCreate, PermisoRead
from database import get_db
from fastapi import Depends

router = SQLAlchemyCRUDRouter(
    schema=PermisoRead,
    create_schema=PermisoCreate,
    db_model=Permiso,
    db=get_db,
    prefix="permisos"
)
