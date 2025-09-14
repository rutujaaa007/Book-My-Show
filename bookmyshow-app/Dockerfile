# ---- Build Stage ----
FROM node:18-alpine AS build

WORKDIR /app

COPY bookmyshow-app/package*.json ./
RUN npm install

COPY bookmyshow-app/ ./

# 👇 Fix for Node 18 crypto issue
ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm run build

# ---- Production Stage ----
FROM node:18-alpine

WORKDIR /app

# Only copy the final build output
COPY --from=build /app/build ./build

# If your app runs with a server (like express):
# COPY --from=build /app/node_modules ./node_modules
# COPY --from=build /app/package*.json ./
# CMD ["npm", "start"]

# If it's static React build (served via nginx):
RUN npm install -g serve
CMD ["serve", "-s", "build", "-l", "3000"]
