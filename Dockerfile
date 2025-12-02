# --- Build stage ---
    FROM node:20-alpine AS build

    WORKDIR /app
    
    # Install deps
    COPY package*.json ./
    RUN npm install
    
    # Copy source
    COPY . .
    
    # Compile TS → JS
    RUN npm run build
    
    # --- Runtime stage ---
    FROM node:20-alpine AS runtime
    
    WORKDIR /app
    
    # Install only prod deps (Encore TS only has dev + runtime)
    COPY package*.json ./
    RUN npm install --omit=dev
    
    # Copy compiled code
    COPY --from=build /app/dist ./dist
    
    # Encore TS always outputs dist/server.js
    CMD ["node", "dist/server.js"]
    