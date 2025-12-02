# --- Build stage ---
FROM node:20-alpine AS build

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Build Encore app (this compiles to dist/)
RUN npm run build

# --- Runtime stage ---
FROM node:20-alpine AS runtime

WORKDIR /app

# Copy built output and production deps
COPY package*.json ./
RUN npm install --omit=dev

COPY --from=build /app/dist ./dist

# Encore TS apps run via compiled JS
CMD ["node", "dist/index.js"]