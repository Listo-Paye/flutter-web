# build vite app and publish to nginx
FROM node:16.13.0 AS build-env
WORKDIR /app
COPY . .

RUN npm install

# build the app
RUN npm run build

# use nginx to deploy
FROM nginx:1.25.2-alpine as release-env

# copy the info of the builded web app to nginx
COPY --from=build-env /app/dist /usr/share/nginx/html

# use html5 navigation mode
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose and run nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
