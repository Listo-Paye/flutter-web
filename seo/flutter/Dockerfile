# Environemnt to install flutter and build web
FROM debian:latest AS build-env

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
RUN flutter build web --release --optimization-level 4

# once heare the app will be compiled and ready to deploy

# use nginx to deploy
FROM nginx:1.25.2-alpine as release-env

# copy the info of the builded web app to nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# use html5 navigation mode
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose and run nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
