FROM node:current-alpine as development
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 5173
CMD ["npm", "run", "dev"]

FROM node:current-alpine as build
# Create root directory
WORKDIR /app
# Copy the package.json from our project to the image
COPY package.json ./
# Install packages needed
RUN npm install
# Copy the whole project
COPY . .
# Build project in static directory
RUN npm run build

FROM httpd:alpine AS release

HEALTHCHECK --interval=60s --timeout=10s --retries=5 \
    CMD make healthz

COPY --from=build --chown=www-data:www-data /app/dist/ /usr/local/apache2/htdocs/
COPY --chown=www-data:www-data ./.htaccess /usr/local/apache2/htdocs/
COPY --chown=www-data:www-data ./httpd.conf /usr/local/apache2/conf/

EXPOSE 80
EXPOSE 443

CMD ["httpd-foreground"]
