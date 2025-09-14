# ---- Build Stage ----
FROM node:18-alpine AS build

WORKDIR /app

# Add build tools (for native deps)
RUN apk add --no-cache python3 make g++

COPY bookmyshow-app/package*.json ./
RUN npm install

COPY bookmyshow-app/ ./

# Fix for Node 18 + Webpack
ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm run build

# ---- Production Stage ----
FROM node:18-alpine

WORKDIR /app

COPY --from=build /app/build ./build

RUN npm install -g serve

EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
