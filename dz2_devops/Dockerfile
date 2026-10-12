FROM python:3.11-alpine AS build
RUN apk add --no-cache build-base postgresql-dev mariadb-connector-c-dev pkgconf
RUN python -m venv /venv
COPY requirements.txt .
RUN /venv/bin/pip install --no-cache-dir -r requirements.txt

FROM python:3.11-alpine
RUN apk add --no-cache libpq mariadb-connector-c
COPY --from=build /venv /venv
ENV PATH=/venv/bin:$PATH
WORKDIR /app
COPY app.py .
ARG VERSION=5.0
RUN echo "$VERSION" > /app/VERSION
ENV PYTHONDONTWRITEBYTECODE=1
STOPSIGNAL SIGINT
CMD ["python", "app.py"]
