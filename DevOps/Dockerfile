# базовый образ из вашего варианта
FROM python:3.11-alpine
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ARG VERSION=dev
RUN echo "$VERSION" > /app/VERSION
# порт приложения внутри, из вашего варианта; то же число в EXPOSE
ENV APP_PORT=5004
ENV PYTHONDONTWRITEBYTECODE=1
ENV MARKER=runlab
EXPOSE 5004
CMD ["python", "app.py"]
