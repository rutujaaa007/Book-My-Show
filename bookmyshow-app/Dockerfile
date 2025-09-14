# ---- Build Stage ----
FROM node:16-alpine AS build

WORKDIR /app

COPY bookmyshow-app/package*.json ./
RUN npm install

COPY bookmyshow-app/ ./
RUN npm run build

# ---- Production Stage ----
FROM node:16-alpine

WORKDIR /app
COPY --from=build /app/build ./build

RUN npm install -g serve
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
