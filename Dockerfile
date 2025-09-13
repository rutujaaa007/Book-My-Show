# Stage 1: Build the React app
FROM node:18-alpine AS build

WORKDIR /app

# Copy package.json and install dependencies
COPY bookmyshow-app/package*.json ./
RUN npm install

# Copy the rest of the source code
COPY bookmyshow-app/ ./

# Build the app
RUN npm run build

# Stage 2: Serve the app using nginx
FROM nginx:alpine

# Copy build output from previous stage to nginx html folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 3000
EXPOSE 3000

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
