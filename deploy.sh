#!/bin/bash
set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

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
  [[ "$DOMAIN" != */* ]] && break || echo -e "${RED}❌ No incluyas rutas. Ej: zyma.lat${NC}"
done

while true; do
  read -p "🔗 Subdominio para API (Backend) [puede ser igual al principal]: " API_DOMAIN
  [[ "$API_DOMAIN" != */* ]] && break || echo -e "${RED}❌ No incluyas /api. Solo el dominio.${NC}"
done

# 👉 Verificar Docker
if ! command -v docker >/dev/null 2>&1; then
  echo -e "${RED}❌ Docker no está instalado.${NC}"
  exit 1
fi

# 👉 Instalar Certbot si falta
if [[ "$USE_SSL" == "s" ]] && ! command -v certbot >/dev/null 2>&1; then
  echo -e "${CYAN}🔧 Instalando Certbot...${NC}"
  sudo apt update && sudo apt install -y certbot
fi

# 👉 Borrar certificados antiguos
if [[ "$USE_SSL" == "s" ]]; then
  echo -e "${CYAN}🧨 Eliminando certificados antiguos...${NC}"
  for domain in "$DOMAIN" "www.$DOMAIN" "$API_DOMAIN"; do
    sudo rm -rf /etc/letsencrypt/live/$domain /etc/letsencrypt/archive/$domain /etc/letsencrypt/renewal/$domain.conf 2>/dev/null || true
  done
fi

# 👉 Sobrescribir prod.conf
if [ -f ./nginx/prod.conf ]; then
  echo -e "${CYAN}⚠️ Ya existe nginx/prod.conf. ¿Sobrescribirlo? (s/n):${NC}"
  read -r OVERWRITE
  [[ "$OVERWRITE" != "s" ]] && echo -e "${RED}🛑 Cancelado.${NC}" && exit 1
fi

# 👉 Crear carpetas necesarias
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

[[ "$USE_SSL" == "s" ]] && cat >> ./nginx/prod.conf <<EOF
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
EOF

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

[[ "$USE_SSL" == "s" ]] && cat >> ./nginx/prod.conf <<EOF
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
EOF

echo "}" >> ./nginx/prod.conf
echo -e "${GREEN}✅ Archivo Nginx generado.${NC}"

# 👉 Eliminar contenedores antiguos
echo -e "${CYAN}🧹 Limpiando contenedores anteriores...${NC}"
docker-compose -f docker-compose.prod.yml down -v || true

# 🐳 Levantar contenedores
echo -e "${CYAN}🐳 Levantando contenedores...${NC}"
docker-compose -f docker-compose.prod.yml up -d --build

# 🧱 Migraciones Alembic
echo -e "${CYAN}🧱 Ejecutando migraciones...${NC}"
docker exec fastapi alembic upgrade head || {
  echo -e "${RED}❌ Error en Alembic.${NC}"
  exit 1
}

# ⏳ Esperar a MySQL
echo -e "${CYAN}⏳ Esperando MySQL...${NC}"
until docker exec barberos-mysql-1 mysqladmin ping -u root -ppassword --silent; do sleep 2; done

# 🔐 Crear usuario admin
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

# 🔑 Generar hash
echo -e "${CYAN}🔐 Generando hash...${NC}"
HASHED_PASS=$(docker run --rm python:3-slim python -c "import bcrypt; print(bcrypt.hashpw(b'$ADMIN_PASS', bcrypt.gensalt()).decode())")

# 👨‍💻 SQL seguro
[[ -n "$ADMIN_AP_MATERNO" ]] && APELLIDO_MAT="'$ADMIN_AP_MATERNO'" || APELLIDO_MAT=NULL

echo -e "${CYAN}📝 Insertando en MySQL...${NC}"
docker exec -i barberos-mysql-1 mysql -u root -ppassword barberia <<EOF
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

# 🔐 Certbot final
if [[ "$USE_SSL" == "s" ]]; then
  echo -e "${CYAN}🔐 Ejecutando Certbot...${NC}"
  sudo certbot certonly --webroot \
    -w ./certbot/www \
    -d $DOMAIN -d www.$DOMAIN -d $API_DOMAIN \
    --email admin@$DOMAIN --agree-tos --non-interactive \
    --deploy-hook "docker compose -f docker-compose.prod.yml exec nginx nginx -s reload"
fi

PROTO="http"
[[ "$USE_SSL" == "s" ]] && PROTO="https"
echo -e "${GREEN}🎉 ¡Despliegue completo! Accede a: ${CYAN}${PROTO}://$DOMAIN${NC}"
