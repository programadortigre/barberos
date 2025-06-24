backend/
├── main.py                  # app FastAPI + rutas básicas
├── database.py              # motor DB, Session, Base (ya tienes)
├── models/                  # todos los modelos SQLAlchemy (barber.py, roles.py, usuarios.py, ...)
│   ├── __init__.py          # para importar todos modelos (recomendado)
│   ├── barber.py
│   ├── usuarios.py
│   ├── roles.py
│   └── ...
├── schemas/                 # modelos Pydantic para validación y serialización
│   ├── usuarios.py
│   ├── roles.py
│   └── ...
├── crud/                    # lógica CRUD (funciones para crear, leer, actualizar, borrar)
│   ├── usuarios.py
│   ├── roles.py
│   └── ...
├── api/                     # routers separados por módulo
│   ├── __init__.py
│   ├── usuarios.py
│   ├── auth.py              # login, refresh tokens, etc.
│   └── roles.py
├── core/                    # configuraciones y utilidades globales
│   ├── security.py          # funciones de seguridad (hash, JWT)
│   ├── config.py            # carga variables entorno, settings
│   └── dependencies.py      # dependencias comunes para rutas (e.g. auth)
└── alembic/                 # migraciones (ya tienes)
