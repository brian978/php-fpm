FROM brian978/php-fpm:8.4

ARG DEBIAN_FRONTEND=noninteractive

# Download PHP tools
RUN curl https://getcomposer.org/composer-stable.phar -o /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN curl https://phar.phpunit.de/phpunit-11.4.4.phar -o /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit

# PHP developer tools
RUN pecl install xdebug && docker-php-ext-enable xdebug