FROM node:18-alpine AS build

WORKDIR /app

COPY bookmyshow-app/package*.json ./
RUN npm install

COPY bookmyshow-app/ ./

# 👇 must be set BEFORE the build command
ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm run build

# If you have a second stage for production, continue here
FROM node:18-alpine

WORKDIR /app

COPY --from=build /app/build ./build

CMD ["npm", "start"]
