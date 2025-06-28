import os
from logging.config import fileConfig
from sqlalchemy import engine_from_config
from sqlalchemy import pool
from alembic import context
from database import Base
# this is the Alembic Config object, which provides
#aqui importar todos los modelos que se van a migrar
import models  # Importa el módulo para que Alembic detecte el modelo

# access to the values within the .ini file in use.
config = context.config

# Interpret the config file for Python logging.
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# Get the database URL from environment variables
MYSQL_USER = os.getenv("MYSQL_USER", "user")  # Default to 'user' if not found
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD", "userpassword")  # Default to 'userpassword'
MYSQL_DATABASE = os.getenv("MYSQL_DATABASE", "barberia")  # Default to 'barberia'

# Construct the database URL
sqlalchemy_url = f"mysql+mysqlconnector://{MYSQL_USER}:{MYSQL_PASSWORD}@mysql/{MYSQL_DATABASE}"

# add your model's MetaData object here
target_metadata = Base.metadata

def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode."""
    context.configure(
        url=sqlalchemy_url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """Run migrations in 'online' mode."""
    connectable = engine_from_config(
        {"sqlalchemy.url": sqlalchemy_url},
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection, target_metadata=target_metadata
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
