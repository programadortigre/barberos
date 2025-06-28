# Dockerfile para desarrollo
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

EXPOSE 3000

CMD ["npx", "nuxi", "dev", "--host", "0.0.0.0"]
