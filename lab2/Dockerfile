

FROM python:3.11-alpine

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

ENV APP_PORT=5004
ENV PYTHONDONTWRITEBYTECODE=1
ENV MARKER=runlab
EXPOSE 5004

ARG VERSION=dev
RUN echo "$VERSION" > /app/VERSION

CMD ["python", "app.py"]
