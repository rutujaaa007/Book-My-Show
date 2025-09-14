FROM node:18-alpine

WORKDIR /app

COPY bookmyshow-app/package*.json ./
RUN npm install

COPY bookmyshow-app/ ./

# 👇 Add this before build
ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm run build

CMD ["npm", "start"]
