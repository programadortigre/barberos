from fastapi_crudrouter import SQLAlchemyCRUDRouter
from sqlalchemy.orm import Session
from fastapi import Depends
from database import get_db
from models.tipos_perfil import TipoPerfil
from schemas.tipos_perfil import TipoPerfilCreate, TipoPerfilRead, TipoPerfilUpdate

router = SQLAlchemyCRUDRouter(
    schema=TipoPerfilRead,
    create_schema=TipoPerfilCreate,
    update_schema=TipoPerfilUpdate,
    db_model=TipoPerfil,
    db=get_db,
    prefix="tipos_perfil",
    tags=["tipos_perfil"]
)
