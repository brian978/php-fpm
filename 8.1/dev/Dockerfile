FROM brian978/php-fpm:8.1

ARG DEBIAN_FRONTEND=noninteractive

# Add NodeJS repository
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

# Add Microsoft repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install the MSSQL required drivers
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools

# Download PHP tools
RUN curl https://getcomposer.org/composer-stable.phar -o /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN curl https://phar.phpunit.de/phpunit-9.5.10.phar -o /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit

# PHP developer tools
RUN pecl install xdebug && docker-php-ext-enable xdebug