# Dockerfile

# 1. Базовый образ с Python 3.11
FROM python:3.11-slim

# 2. Устанавливаем зависимости для psycopg2 и сборки
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    python3-dev \
    libc-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Устанавливаем Poetry (в режиме, когда virtualenv НЕ создаётся)
ENV POETRY_VERSION=1.8.0
RUN pip install "poetry==$POETRY_VERSION"

# Отключаем создание virtualenv внутри контейнера
ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR='/var/cache/pypoetry'

# 4. Создаём рабочую директорию и копируем файлы
WORKDIR /app
COPY pyproject.toml poetry.lock /app/

# 5. Устанавливаем зависимости через Poetry
RUN poetry install --no-interaction --no-ansi --no-root

# 6. Копируем весь код
COPY app /app/app

# 7. Создаем непривилегированного пользователя
RUN groupadd -g 3000 appgroup && \
    useradd -u 1000 -g appgroup -s /bin/bash -m appuser && \
    chown -R appuser:appgroup /app

# 8. Устанавливаем переменную окружения на рабочую папку
ENV PYTHONPATH="/app/app"

# 9. Переключаемся на непривилегированного пользователя
USER appuser

# 10. По умолчанию запускаем скрипт создания таблицы
ENTRYPOINT ["python", "-u", "app/main.py"]
