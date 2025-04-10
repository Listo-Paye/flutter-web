# Environemnt to install flutter and build web
FROM debian:latest AS build

# install all needed stuff
RUN apt-get update
RUN apt-get install -y curl git unzip

# define variables
ARG FLUTTER_SDK=/usr/local/flutter
ARG APP=/app/

#clone flutter
RUN git clone -b stable https://github.com/flutter/flutter.git $FLUTTER_SDK

# setup the flutter path as an enviromental variable
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

# Start to run Flutter commands
# doctor to see if all was installes ok
RUN flutter doctor -v

# create folder to copy source code
RUN mkdir $APP
# copy source code to folder
COPY . $APP
# stup new folder as the working directory
WORKDIR $APP

# Run build: 1 - clean, 2 - pub get, 3 - build web
RUN flutter clean
RUN flutter pub get
RUN flutter build web -t lib/main_dev.dart --release

FROM httpd:alpine AS release

HEALTHCHECK --interval=60s --timeout=10s --retries=5 \
    CMD make healthz

COPY --from=build --chown=www-data:www-data /app/build/web /usr/local/apache2/htdocs/
COPY --chown=www-data:www-data ./.htaccess /usr/local/apache2/htdocs/
COPY --chown=www-data:www-data ./httpd.conf /usr/local/apache2/conf/

EXPOSE 80
EXPOSE 443

CMD ["httpd-foreground"]
