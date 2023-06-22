FROM brian978/php-fpm:8.1

ARG DEBIAN_FRONTEND=noninteractive

# Add NodeJS repository
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -

# Download PHP tools
RUN curl https://getcomposer.org/composer-stable.phar -o /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN curl https://phar.phpunit.de/phpunit-10.2.2.phar -o /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit

# PHP developer tools
RUN pecl install xdebug && docker-php-ext-enable xdebug