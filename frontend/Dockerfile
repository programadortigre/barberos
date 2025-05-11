# Usar la imagen oficial de Node.js
FROM node:18

# Definir el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar solo el package.json y package-lock.json para optimizar la instalación de dependencias
COPY package*.json ./

# Instalar las dependencias
RUN npm install

# Copiar todo el resto de los archivos del proyecto
COPY . .

# Construir el proyecto de Nuxt
RUN npm run build

# Exponer el puerto 3000 para acceder a la aplicación Nuxt
EXPOSE 3000

# Ejecutar el servidor de producción de Nuxt
CMD ["npm", "run", "start"]
