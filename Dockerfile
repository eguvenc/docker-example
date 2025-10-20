
FROM php:8.2-fpm

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql  # Install necessary extensions

COPY ./src /var/www/html  # Paste source code to container

CMD ["php-fpm"]  # command to run when the container starts
