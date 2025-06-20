#!/bin/bash

echo "🚀 Iniciando despliegue..."

# Preguntar al usuario
read -p "👉 Dominio principal (Frontend): " DOMAIN
read -p "👉 Subdominio para API (Backend): " API_DOMAIN

# Crear el archivo Nginx dinámicamente
mkdir -p ./nginx

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
}

server {
    listen 80;
    server_name $API_DOMAIN;

    location / {
        proxy_pass http://backend:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

echo "✅ Archivo Nginx generado."

# Levantar contenedores
docker compose -f docker-compose.prod.yml up -d --build
echo "📦 Contenedores desplegados."

# SSL (opcional)
read -p "¿Quieres generar certificados SSL con Certbot ahora? (s/n): " CERT
if [ "$CERT" = "s" ]; then
    sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN -d $API_DOMAIN
fi

echo "🎉 ¡Despliegue completo! Accede a: https://$DOMAIN"
