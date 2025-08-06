# Using official Node.js base image
FROM node:18-alpine

# Setting working directory
WORKDIR /app

# Copying package files first to install dependencies
COPY src/package*.json ./
RUN npm install

# Copying the rest of the app
COPY src/ .

# Exposing port 3000
EXPOSE 3000

# Starting the app
CMD ["node", "start"]
