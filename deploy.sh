#!/bin/bash
set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

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
until docker exec mysql mysqladmin ping -h localhost -uuser -puserpassword --silent; do
  sleep 2
done

echo -e "${CYAN}==> 5. Ejecutando migraciones con Alembic...${NC}"
docker exec fastapi alembic upgrade head || echo -e "${RED}⚠️  No se pudo ejecutar Alembic (¿ya migrado?). Continuando...${NC}"

# INSERTA UN ADMIN INICIAL SOLO SI NO EXISTE
echo -e "${CYAN}==> 6. Insertando usuario admin si no existe...${NC}"
docker exec -i fastapi mysql -uuser -puserpassword barberia <<'EOF'
INSERT INTO personas (id, nombres, apellidos, fecha_nacimiento, direccion, telefono, correo)
SELECT 1, 'Admin', 'Principal', '1990-01-01', 'Lima', '999999999', 'admin@zyma.lat'
FROM DUAL
WHERE NOT EXISTS (SELECT id FROM personas WHERE id = 1);

INSERT INTO usuarios (id, username, password, rol_id, persona_id, estado, created_at, updated_at)
SELECT 1, 'admin', '$2b$12$eFKEkGjtsCH9nP85mR8GzuJXG.xcMQ2mAvzm.d4N1D7ybdVbfxKaC', 2, 1, 'activo', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT id FROM usuarios WHERE id = 1);
EOF

echo -e "${GREEN}✅ Despliegue completo y plataforma operativa en:${NC} https://zyma.lat"
