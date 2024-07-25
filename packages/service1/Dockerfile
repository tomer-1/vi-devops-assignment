# Use an official Node.js runtime as a parent image
FROM node:lts-alpine3.20

# Set environment variables
# ENV MONGODB_URL=mongodb://your_mongo_db_url_here

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port on which your app will run
EXPOSE 3000

# Define the command to run your app
CMD ["node", "index.js"]
