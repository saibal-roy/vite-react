# ================================
# Stage 1 — Build the Vite app
# ================================
FROM node:22-alpine AS build

WORKDIR /app

# Copy dependency files first (for better caching)
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the production bundle (goes to /app/dist)
RUN npm run build

# ================================
# Stage 2 — Serve using Nginx
# ================================
FROM nginx:stable-alpine AS production

# Copy custom nginx configuration (optional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the build output from previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
