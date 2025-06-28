# api/perfiles.py
from fastapi_crudrouter import SQLAlchemyCRUDRouter
from database import get_db
from sqlalchemy.orm import Session
from models.perfiles import Perfil
from schemas.perfiles import PerfilCreate, PerfilRead, PerfilUpdate

router = SQLAlchemyCRUDRouter(
    schema=PerfilRead,
    create_schema=PerfilCreate,
    update_schema=PerfilUpdate,
    db_model=Perfil,
    db=get_db,
    prefix="perfiles",
    tags=["perfiles"]
)
