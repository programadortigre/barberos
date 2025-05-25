"""Fix default timestamps personas

Revision ID: e689ed3b42cb
Revises: 70c5f2b27451
Create Date: 2025-05-16 15:13:25.784501

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e689ed3b42cb'
down_revision: Union[str, None] = '70c5f2b27451'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade():
    op.execute(
        "ALTER TABLE personas MODIFY created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP"
    )
    op.execute(
        "ALTER TABLE personas MODIFY updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"
    )


def downgrade():
    op.execute(
        "ALTER TABLE personas MODIFY created_at DATETIME NOT NULL"
    )
    op.execute(
        "ALTER TABLE personas MODIFY updated_at DATETIME NOT NULL"
    )
