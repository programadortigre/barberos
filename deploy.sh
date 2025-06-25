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
until docker exec mysql mysqladmin ping -h127.0.0.1 -uuser -puserpassword --silent &> /dev/null; do
  echo -e "${RED}MySQL no está listo aún. Esperando...${NC}"
  sleep 3
done
echo -e "${GREEN}✅ MySQL está listo.${NC}"

echo -e "${CYAN}==> 5. Ejecutando migraciones con Alembic...${NC}"
docker exec fastapi alembic upgrade head || echo -e "${RED}⚠️  No se pudo ejecutar Alembic (¿ya migrado?). Continuando...${NC}"

# INSERTA UN ADMIN INICIAL SOLO SI NO EXISTE
echo -e "${CYAN}==> 6. Insertando usuario admin si no existe...${NC}"
docker exec -i mysql mysql -uuser -puserpassword barberia <<'EOF'
-- Insertar rol ADMIN si no existe
INSERT INTO roles (id, nombre, descripcion, created_at, updated_at)
SELECT 2, 'ADMIN', 'Acceso total al sistema. Puede gestionar todo.', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT id FROM roles WHERE id = 2);

-- Insertar persona si no existe
INSERT INTO personas (id, tipo_documento, dni, nombres, apellido_paterno, apellido_materno, fecha_nacimiento, genero, direccion_cifrada, telefono_cifrado, correo_cifrado)
SELECT 1, 'DNI', '00000001', 'Administrador', 'Principal', '', '1990-01-01', 'M',
       AES_ENCRYPT('Lima, Perú', 'clave_para_mysql'),
       AES_ENCRYPT('999999999', 'clave_para_mysql'),
       AES_ENCRYPT('admin@zyma.lat', 'clave_para_mysql')
FROM DUAL
WHERE NOT EXISTS (SELECT id FROM personas WHERE id = 1);

-- Insertar usuario admin si no existe
INSERT INTO usuarios (id, username, password, rol_id, persona_id, estado, created_at, updated_at)
SELECT 1, 'admin', '$2b$12$D934RFLr6F3oMo7UT4n4MOG2xarK2DLRQdL2p1Gpdn3L084w2nfuK', 2, 1, 'activo', NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT id FROM usuarios WHERE id = 1);
EOF


echo -e "${GREEN}✅ Despliegue completo y plataforma operativa en:${NC} https://zyma.lat"
