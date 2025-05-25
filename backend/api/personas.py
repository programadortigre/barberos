from fastapi_crudrouter import SQLAlchemyCRUDRouter
from models.personas import Persona
from schemas.personas import PersonaRead, PersonaCreate
from database import get_db

router = SQLAlchemyCRUDRouter(
    schema=PersonaRead,
    create_schema=PersonaCreate,
    db_model=Persona,
    db=get_db,  # importante: función que genera sesión
    prefix="personas",
    tags=["Personas"]
)
