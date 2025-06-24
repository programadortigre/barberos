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
for domain in "$DOMAIN" "www.$DOMAIN" "$API_DOMAIN"; do
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

echo -e "${CYAN}🔐 Creación de usuario administrador...${NC}"
read -p "👤 Nombre completo: " ADMIN_NOMBRE
read -p "🔢 DNI: " ADMIN_DNI

IFS=' ' read -ra NOMBRES <<< "$ADMIN_NOMBRE"
ADMIN_NOMBRE="${NOMBRES[0]}"
ADMIN_AP_PATERNO="${NOMBRES[1]}"
ADMIN_AP_MATERNO="${NOMBRES[2]:-}"

read -p "📅 Fecha nacimiento (YYYY-MM-DD): " ADMIN_FECHA_NAC
read -p "🚻 Género (M/F/O): " ADMIN_GENERO
read -p "🏠 Dirección: " ADMIN_DIRECCION
read -p "📞 Teléfono: " ADMIN_TELEFONO
read -p "📧 Email: " ADMIN_EMAIL
read -s -p "🔐 Clave de cifrado AES: " ENCRYPTION_KEY
echo

while true; do
    read -p "👤 Usuario admin: " ADMIN_USER
    read -s -p "🔑 Contraseña: " ADMIN_PASS
    echo
    read -s -p "🔄 Confirmar contraseña: " ADMIN_PASS_CONFIRM
    echo
    [[ "$ADMIN_PASS" == "$ADMIN_PASS_CONFIRM" ]] && break || echo -e "${RED}❌ No coinciden.${NC}"
done

# Sanitizar entradas para SQL
ADMIN_NOMBRE="${ADMIN_NOMBRE//\'/\\\'}"
ADMIN_AP_PATERNO="${ADMIN_AP_PATERNO//\'/\\\'}"
ADMIN_AP_MATERNO="${ADMIN_AP_MATERNO//\'/\\\'}"
ADMIN_DIRECCION="${ADMIN_DIRECCION//\'/\\\'}"
ADMIN_TELEFONO="${ADMIN_TELEFONO//\'/\\\'}"
ADMIN_EMAIL="${ADMIN_EMAIL//\'/\\\'}"

echo -e "${CYAN}🔐 Generando hash...${NC}"
HASHED_PASS=$($DOCKER_COMPOSE_CMD -f docker-compose.prod.yml exec backend python -c "import bcrypt; print(bcrypt.hashpw('$ADMIN_PASS'.encode(), bcrypt.gensalt()).decode())")

[[ -n "$ADMIN_AP_MATERNO" ]] && APELLIDO_MAT="'$ADMIN_AP_MATERNO'" || APELLIDO_MAT="NULL"

echo -e "${CYAN}📝 Insertando en MySQL...${NC}"
docker exec -i "$MYSQL_CONTAINER" mysql -u root -prootpassword barberia <<EOF
INSERT INTO personas (
  tipo_documento, dni, nombres, apellido_paterno, apellido_materno,
  fecha_nacimiento, genero, direccion_cifrada, telefono_cifrado, correo_cifrado
) VALUES (
  'DNI', '$ADMIN_DNI', '$ADMIN_NOMBRE', '$ADMIN_AP_PATERNO', $APELLIDO_MAT,
  '$ADMIN_FECHA_NAC', '$ADMIN_GENERO',
  AES_ENCRYPT('$ADMIN_DIRECCION', '$ENCRYPTION_KEY'),
  AES_ENCRYPT('$ADMIN_TELEFONO', '$ENCRYPTION_KEY'),
  AES_ENCRYPT('$ADMIN_EMAIL', '$ENCRYPTION_KEY')
);

SET @persona_id = LAST_INSERT_ID();

INSERT INTO usuarios (
  persona_id, username, password_hash, rol_id, estado, intentos_fallidos
) VALUES (
  @persona_id, '$ADMIN_USER', '$HASHED_PASS', 2, 'activo', 0
);

INSERT INTO perfiles (persona_id, tipo_perfil_id) VALUES (@persona_id, 1);
EOF

echo -e "${GREEN}✅ Usuario '$ADMIN_USER' creado correctamente.${NC}"

if [[ "$USE_SSL" == "s" ]]; then
  echo -e "${CYAN}🔐 Solicitando certificados SSL...${NC}"
  if docker run --rm \
    -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
    -v "$(pwd)/certbot/www:/var/www/certbot" \
    certbot/certbot certonly --webroot --webroot-path=/var/www/certbot \
    --email admin@$DOMAIN --agree-tos --no-eff-email \
    -d $DOMAIN -d www.$DOMAIN -d $API_DOMAIN; then

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