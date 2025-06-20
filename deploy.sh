#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}🚀 Iniciando despliegue en modo FINAL BOSS...${NC}"

# 👉 Preguntar si usará SSL
while true; do
  read -p "🔐 ¿Quieres usar SSL con Let's Encrypt? (s/n): " USE_SSL
  case $USE_SSL in
    [Ss]* ) USE_SSL="s"; break;;
    [Nn]* ) USE_SSL="n"; break;;
    * ) echo -e "${RED}❌ Por favor responde con 's' o 'n'.${NC}";;
  esac
done

# 👉 Pedir dominios
while true; do
  read -p "🌍 Dominio principal (Frontend): " DOMAIN
  if [[ "$DOMAIN" == *"/"* ]]; then
    echo -e "${RED}❌ No incluyas rutas como /api. Solo el dominio, ej: zyma.lat${NC}"
  else
    break
  fi
done

while true; do
  read -p "🔗 Subdominio para API (Backend) [puede ser igual al principal]: " API_DOMAIN
  if [[ "$API_DOMAIN" == *"/"* ]]; then
    echo -e "${RED}❌ No incluyas /api. Solo el dominio (ej: api.zyma.lat o zyma.lat)${NC}"
  else
    break
  fi
done

# 👉 Verificar Docker
if ! command -v docker >/dev/null 2>&1; then
  echo -e "${RED}❌ Docker no está instalado. Aborta el despliegue.${NC}"
  exit 1
fi

# 👉 Instalar Certbot si falta
if [[ "$USE_SSL" == "s" ]]; then
  if ! command -v certbot >/dev/null 2>&1; then
    echo -e "${CYAN}🔧 Certbot no encontrado. Instalando...${NC}"
    sudo apt update
    sudo apt install -y certbot
  fi
fi

# 👉 Borrar certificados antiguos
if [[ "$USE_SSL" == "s" ]]; then
  echo -e "${CYAN}🧨 Borrando certificados antiguos si existen...${NC}"
  for domain in "$DOMAIN" "www.$DOMAIN" "$API_DOMAIN"; do
    sudo rm -rf /etc/letsencrypt/live/$domain /etc/letsencrypt/archive/$domain /etc/letsencrypt/renewal/$domain.conf 2>/dev/null || true
  done
fi

# 👉 Preguntar antes de sobrescribir prod.conf
if [ -f ./nginx/prod.conf ]; then
  echo -e "${CYAN}⚠️ Ya existe nginx/prod.conf. ¿Sobrescribirlo? (s/n):${NC}"
  read -r OVERWRITE
  if [[ "$OVERWRITE" != "s" ]]; then
    echo -e "${RED}🛑 Despliegue cancelado por el usuario.${NC}"
    exit 1
  fi
fi

# 👉 Crear carpetas necesarias
echo -e "${CYAN}📁 Creando carpetas necesarias...${NC}"
mkdir -p ./nginx
[[ "$USE_SSL" == "s" ]] && mkdir -p ./certbot/www ./certbot/conf

# 👉 Generar configuración Nginx
echo -e "${CYAN}📝 Generando configuración Nginx...${NC}"
cat > ./nginx/prod.conf <<EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location / {
        proxy_pass http://frontend:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /api/ {
        rewrite ^/api/?(.*)$ /\$1 break;
        proxy_pass http://backend:8000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
EOF

if [[ "$USE_SSL" == "s" ]]; then
cat >> ./nginx/prod.conf <<EOF
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
EOF
fi

cat >> ./nginx/prod.conf <<EOF
}

server {
    listen 80;
    server_name $API_DOMAIN;

    location / {
        proxy_pass http://backend:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
EOF

if [[ "$USE_SSL" == "s" ]]; then
cat >> ./nginx/prod.conf <<EOF
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
EOF
fi

echo "}" >> ./nginx/prod.conf

echo -e "${GREEN}✅ Archivo Nginx generado.${NC}"

# 👉 Borrar contenedores viejos
echo -e "${CYAN}🧹 Eliminando contenedores antiguos...${NC}"
docker compose -f docker-compose.prod.yml down -v || true

# 🐳 Levantar nuevos contenedores
echo -e "${CYAN}🐳 Levantando nuevos contenedores...${NC}"
docker compose -f docker-compose.prod.yml up -d --build

# 🔐 Obtener nuevos certificados
if [[ "$USE_SSL" == "s" ]]; then
  echo -e "${CYAN}🔐 Ejecutando Certbot...${NC}"
  sudo certbot certonly --webroot \
    -w ./certbot/www \
    -d $DOMAIN -d www.$DOMAIN -d $API_DOMAIN \
    --deploy-hook "docker exec nginx nginx -s reload"
fi

PROTO="http"
[[ "$USE_SSL" == "s" ]] && PROTO="https"

echo -e "${GREEN}🎉 ¡Despliegue completo! Accede a: ${CYAN}${PROTO}://$DOMAIN${NC}"
