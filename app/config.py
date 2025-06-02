import os
from typing import Optional


def get_env_or_fail(var_name: str) -> str:
    """Get environment variable or exit with error."""
    value: Optional[str] = os.getenv(var_name)
    if not value:
        raise ValueError(f"Environment variable {var_name} is not set")
    return value


def get_database_url() -> str:
    """Construct database URL from environment variables."""
    db_host = get_env_or_fail("DB_HOST")
    db_port = get_env_or_fail("DB_PORT")
    db_name = get_env_or_fail("DB_NAME")
    db_user = get_env_or_fail("DB_USER")
    db_password = get_env_or_fail("DB_PASSWORD")

    return f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
