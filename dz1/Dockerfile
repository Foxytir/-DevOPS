FROM python:3.11-alpine

WORKDIR /app

ARG VERSION=1.0
RUN echo "${VERSION}" > /app/VERSION

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5004

CMD ["python", "app.py"]
