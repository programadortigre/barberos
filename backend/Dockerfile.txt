FROM python:3.11-slim

# Evita conflictos con stdin/out, guarda logs correctamente
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Crear directorio de trabajo
WORKDIR /app

# Copiar e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código (esto será sobrescrito por el volumen en desarrollo)
COPY . .

# Exponer el puerto
EXPOSE 8000

# Usar uvicorn como entrypoint por defecto (esto se puede sobrescribir en docker-compose)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
