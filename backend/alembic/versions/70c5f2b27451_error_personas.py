"""error personas

Revision ID: 70c5f2b27451
Revises: 94cfcfb8354f
Create Date: 2025-05-16 15:11:15.610902

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '70c5f2b27451'
down_revision: Union[str, None] = '94cfcfb8354f'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass
