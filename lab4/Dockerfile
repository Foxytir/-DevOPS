# --- стадия сборки: зависимости компилируются в виртуальное окружение ---
FROM python:3.11-alpine AS build
WORKDIR /src
RUN apk add --no-cache build-base postgresql-dev mariadb-dev
RUN python -m venv /venv
COPY requirements.txt .
RUN /venv/bin/pip install --no-cache-dir -r requirements.txt

# --- итоговый образ: только окружение и приложение, без компиляторов ---
FROM python:3.11-alpine
COPY --from=build /venv /venv
WORKDIR /app
COPY app.py .

ARG VERSION=4.0
RUN echo "$VERSION" > /app/VERSION

ENV PYTHONDONTWRITEBYTECODE=1 PATH="/venv/bin:$PATH"
# Flask под PID 1 не обрабатывает SIGTERM и ждёт KILL через 10 секунд;
# на SIGINT он завершается сразу — задачи Swarm меняются без паузы
STOPSIGNAL SIGINT
CMD ["python", "app.py"]
