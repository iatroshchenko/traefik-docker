FROM nginx:1.17-alpine

COPY ./conf /etc/nginx/conf.d

WORKDIR /app
