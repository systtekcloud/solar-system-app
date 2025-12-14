# Usa una imagen base actualizada
FROM node:18-alpine AS base

# Instala dumb-init para manejar señales correctamente
RUN apk add --no-cache dumb-init

# Crea un usuario no privilegiado
RUN addgroup -g 1001 -S nodejs && \
  adduser -S nodejs -u 1001

WORKDIR /usr/app

# Copia archivos de dependencias con permisos correctos
COPY --chown=nodejs:nodejs package*.json ./

# Instala dependencias (usa npm ci para builds reproducibles)
RUN npm ci && \
  npm cache clean --force

# Copia el código de la aplicación con permisos correctos
COPY --chown=nodejs:nodejs . .

# Cambia al usuario no privilegiado
USER nodejs

# Expone el puerto
EXPOSE 3000

# Health check para verificar que la aplicación está funcionando
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/live', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Usa dumb-init para manejar señales correctamente (mejor que npm start)
ENTRYPOINT ["dumb-init", "--"]

# NO incluyas ENV con credenciales aquí - se pasan en runtime
# Las variables MONGO_URI, MONGO_USERNAME, MONGO_PASSWORD se deben pasar con docker run -e
CMD ["npm", "run", "start"]