FROM php:8.3-fpm-alpine

RUN mkdir /app

WORKDIR /app

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

## install mysql
RUN docker-php-ext-install mysqli pdo pdo_mysql

# install postgres
RUN apk update && apk add postgresql-dev \
  && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
  && docker-php-ext-install pdo_pgsql

# install zip
RUN apk add --no-cache --update zip unzip libzip-dev
RUN docker-php-ext-configure zip && docker-php-ext-install zip

# install xdebug
RUN apk add --no-cache $PHPIZE_DEPS \
    && apk add linux-headers \
    && pecl install xdebug-3.3.0 \
    && docker-php-ext-enable xdebug
