# Set up the OS
FROM node:20-alpine

# Set up the working directory
WORKDIR /app

# Copy all the files
COPY . .

# Clean install all dependencies
RUN npm ci

# Install the serve package globally
RUN npm install -g serve

# Build the app
RUN npm run build

# Expose the port
EXPOSE 3001

# Create a non root new user with UID 10014
RUN addgroup -g 10014 testgroup && \
    adduser  --disabled-password  --no-create-home --uid 10014 --ingroup testgroup testuser

# Set the non-root user
USER 10014

# Run the application
CMD ["serve","dist","--single", "-l","3001"]
