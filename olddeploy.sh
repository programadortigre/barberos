#!/bin/bash
set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[1;36m'
NC='\033[0m'

# Detectar versión de docker compose
if docker compose version &>/dev/null; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    DOCKER_COMPOSE_CMD="docker-compose"
fi

echo -e "${CYAN}🚀 Iniciando despliegue FINAL BOSS...${NC}"

while true; do
  read -p "🔐 ¿Quieres usar SSL con Let's Encrypt? (s/n): " USE_SSL
  case $USE_SSL in
    [Ss]*) USE_SSL="s"; break ;;
    [Nn]*) USE_SSL="n"; break ;;
    *) echo -e "${RED}❌ Por favor responde con 's' o 'n'.${NC}" ;;
  esac
done

while true; do
  read -p "🌍 Dominio principal (Frontend): " DOMAIN
  if [[ "$DOMAIN" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    break
  else
    echo -e "${RED}❌ Formato inválido. Ej: zyma.lat${NC}"
  fi
done

while true; do
  read -p "🔗 Subdominio para API (Backend) [puede ser igual al principal]: " API_DOMAIN
  if [[ "$API_DOMAIN" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    break
  else
    echo -e "${RED}❌ Formato inválido. Ej: api.zyma.lat${NC}"
  fi
done

if ! command -v docker >/dev/null 2>&1; then
  echo -e "${RED}❌ Docker no está instalado.${NC}"
  exit 1
fi

echo -e "${CYAN}🧹 Limpiando certificados antiguos...${NC}"
for domain in "$DOMAIN" "www.$DOMAIN"; do
  sudo rm -rf ./certbot/conf/live/$domain ./certbot/conf/archive/$domain ./certbot/conf/renewal/$domain.conf 2>/dev/null || true
done

mkdir -p ./nginx ./certbot/www ./certbot/conf

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
        rewrite ^/api/?(.*)\$ /\$1 break;
        proxy_pass http://backend:8000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}

server {
    listen 80;
    server_name $API_DOMAIN;

    location / {
        proxy_pass http://backend:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}
EOF

if [[ "$USE_SSL" == "s" ]]; then
cat >> ./nginx/prod.conf <<EOF

server {
    listen 443 ssl;
    server_name $DOMAIN www.$DOMAIN;

    ssl_certificate     /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;

    location / {
        proxy_pass http://frontend:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /api/ {
        rewrite ^/api/?(.*)\$ /\$1 break;
        proxy_pass http://backend:8000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}

server {
    listen 443 ssl;
    server_name $API_DOMAIN;

    ssl_certificate     /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;

    location / {
        proxy_pass http://backend:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
fi

echo -e "${GREEN}✅ Configuración Nginx generada.${NC}"

echo -e "${CYAN}🧹 Eliminando contenedores anteriores...${NC}"
$DOCKER_COMPOSE_CMD -f docker-compose.prod.yml down -v || true

echo -e "${CYAN}🐳 Levantando contenedores...${NC}"
$DOCKER_COMPOSE_CMD -f docker-compose.prod.yml up -d --build

# Reiniciar Nginx para asegurar el tráfico ACME
$DOCKER_COMPOSE_CMD -f docker-compose.prod.yml restart nginx

echo -e "${CYAN}🧱 Ejecutando migraciones Alembic...${NC}"
$DOCKER_COMPOSE_CMD -f docker-compose.prod.yml exec backend alembic upgrade head || {
  echo -e "${RED}❌ Error en migraciones.${NC}"
  exit 1
}

echo -e "${CYAN}⏳ Esperando MySQL...${NC}"
MYSQL_CONTAINER="$($DOCKER_COMPOSE_CMD -f docker-compose.prod.yml ps -q mysql)"
until docker exec "$MYSQL_CONTAINER" mysqladmin ping -u root -prootpassword --silent; do sleep 2; done

echo -e "${GREEN}✅ Base de datos migrada exitosamente${NC}"
echo -e "${CYAN}ℹ️  No se creó ningún usuario administrador${NC}"

if [[ "$USE_SSL" == "s" ]]; then
  echo -e "${CYAN}🔐 Solicitando certificados SSL...${NC}"
  if docker run --rm \
    -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
    -v "$(pwd)/certbot/www:/var/www/certbot" \
    certbot/certbot certonly --webroot --webroot-path=/var/www/certbot \
    --email admin@$DOMAIN --agree-tos --no-eff-email \
    -d $DOMAIN -d www.$DOMAIN; then

    echo -e "${CYAN}🔁 Verificando configuración Nginx...${NC}"
    $DOCKER_COMPOSE_CMD -f docker-compose.prod.yml exec nginx nginx -t

    echo -e "${CYAN}🔁 Reiniciando Nginx...${NC}"
    $DOCKER_COMPOSE_CMD -f docker-compose.prod.yml exec nginx nginx -s reload
  else
    echo -e "${RED}❌ Falló la obtención de certificados. Continuando sin SSL.${NC}"
    USE_SSL="n"
  fi
fi

PROTO="http"
[[ "$USE_SSL" == "s" ]] && PROTO="https"
echo -e "${GREEN}🎉 ¡Despliegue completo! Accede a: ${CYAN}${PROTO}://$DOMAIN${NC}"