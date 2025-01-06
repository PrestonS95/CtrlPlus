# Use Node.js base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy app source code
COPY . .

# Build the React client
RUN npm run client:build

# Set environment variables
ENV PORT=4000
ENV DATABASE_URL=postgres://postgres:postgres@postgres:5432/ctrlplus
ENV JWT_SECRET=dont_tell_a_soul

# Expose port
EXPOSE 4000

# Create docker-compose.yml for Postgres service
RUN echo "version: '3'\n\
  services:\n\
  app:\n\
  build: .\n\
  ports:\n\
  - '4000:4000'\n\
  depends_on:\n\
  - postgres\n\
  environment:\n\
  - DATABASE_URL=postgres://postgres:postgres@postgres:5432/ctrlplus\n\
  postgres:\n\
  image: postgres:13\n\
  ports:\n\
  - '5432:5432'\n\
  environment:\n\
  - POSTGRES_USER=postgres\n\
  - POSTGRES_PASSWORD=postgres\n\
  - POSTGRES_DB=ctrlplus\n\
  volumes:\n\
  - postgres_data:/var/lib/postgresql/data\n\
  volumes:\n\
  postgres_data:" > docker-compose.yml

# Start the application
CMD ["npm", "start"]
