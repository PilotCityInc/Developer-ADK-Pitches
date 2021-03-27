# This dockerfile is meant for in-container development
FROM node:14.16.0
WORKDIR /usr/src/app

# Install the application's dependencies into the node_modules's cache directory.
COPY package*.json ./
# RUN yarn global add @vue/cli
RUN yarn 
# Create and define the application's working directory.
WORKDIR /usr/src/app
COPY . .
EXPOSE 8080

CMD [ "yarn", "run", "serve" ]