#!/bin/bash
set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

# --- Colores para los logs ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}==> 0. Verificando carpeta certs y acme.json...${NC}"
mkdir -p certs
touch certs/acme.json
chmod 600 certs/acme.json

echo -e "${CYAN}==> 1. Parando contenedores previos...${NC}"
docker-compose -f docker-compose.prod.yml down --remove-orphans || true

echo -e "${CYAN}==> 2. Construyendo contenedores...${NC}"
docker-compose -f docker-compose.prod.yml build

echo -e "${CYAN}==> 3. Levantando servicios en segundo plano...${NC}"
docker-compose -f docker-compose.prod.yml up -d

echo -e "${CYAN}==> 4. Esperando a que MySQL esté listo...${NC}"
# Usamos el usuario/password definidos en docker-compose.prod.yml para el healthcheck
until docker exec mysql mysqladmin ping -h127.0.0.1 -uuser -puserpassword --silent &> /dev/null; do
  echo -e "${RED}MySQL no está listo aún. Esperando...${NC}"
  sleep 3
done
echo -e "${GREEN}✅ MySQL está listo.${NC}"

echo -e "${CYAN}==> 5. Importando la base de datos completa desde barberia.sql...${NC}"
cat ./barberia.sql | docker exec -i mysql mysql -uuser -puserpassword barberia
echo -e "${GREEN}✅ Base de datos importada correctamente.${NC}"

echo -e "${GREEN}✅ Despliegue completo y plataforma operativa en:${NC} https://zyma.lat"