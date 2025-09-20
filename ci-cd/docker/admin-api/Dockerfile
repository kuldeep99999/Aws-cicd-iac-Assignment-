FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

COPY . .

RUN npm run build

FROM node:18-alpine AS runtime

RUN apk --no-cache add ca-certificates && \
    apk --no-cache update

WORKDIR /app

RUN addgroup -g 1001 -S nodejs && \
    adduser -S adminapi -u 1001

COPY --from=builder --chown=adminapi:nodejs /app/dist ./dist
COPY --from=builder --chown=adminapi:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=adminapi:nodejs /app/package*.json ./

RUN chown -R adminapi:nodejs /app

EXPOSE 8080

USER adminapi

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

CMD ["node", "dist/server.js"]
