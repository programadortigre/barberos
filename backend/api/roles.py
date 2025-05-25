from fastapi_crudrouter import SQLAlchemyCRUDRouter
from models.roles import Rol
from schemas.roles import RolRead, RolCreate
from database import get_db

router = SQLAlchemyCRUDRouter(
    schema=RolRead,
    create_schema=RolCreate,
    db_model=Rol,
    db=get_db,  # importante: función que genera sesión
    prefix="roles",
    tags=["Roles"]
)
