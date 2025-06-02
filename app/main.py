# app/main.py

import sys
from sqlalchemy import create_engine

from config import get_database_url
from models import Base


def main() -> None:
    try:
        # Получаем URL для подключения к базе данных
        database_url = get_database_url()

        # Создаем движок SQLAlchemy
        engine = create_engine(database_url)

        # Создаем все таблицы
        Base.metadata.create_all(engine)

        print("Database tables created successfully!")

    except Exception as e:
        print(f"Error: {str(e)}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
