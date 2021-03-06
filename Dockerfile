FROM php:7.4-fpm

ARG DEBIAN_FRONTEND=noninteractive

# Prequisites
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gnupg curl apt-transport-https apt-utils

# Add Microsoft repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Add NodeJS repository
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -

# Add Yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install the MSSQL required drivers
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools \
    && apt-get install -y vim unixodbc-dev

# Download PHP tools
RUN curl https://getcomposer.org/composer-stable.phar -o /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN curl https://phar.phpunit.de/phpunit-9.5.0.phar -o /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit

# PHP setup
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        g++ \
        git \
        libonig-dev \
        libzip-dev \ 
        libbz2-dev \
        libc-client-dev \
        libcurl4-gnutls-dev \
        libedit-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libkrb5-dev \
        libldap2-dev \
        libmagickwand-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libpq-dev \
        libsodium-dev \
        libsqlite3-dev \
        libssl-dev \
        libreadline-dev \
        libxml2-dev \
        libxslt1-dev \
        librabbitmq-dev \
        wget \
        unzip \
        zlib1g-dev \
        nodejs \
        yarn \
        iputils-ping \
        locales \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        bz2 \
        calendar \
        ctype \
        curl \
        fileinfo \
        ftp \
        gettext \
        iconv \
        intl \
        mbstring \
        mysqli \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        phar \
        pgsql \
        readline \
        soap \
        sockets \
        sodium \
        xml \
        xmlrpc \
        xmlwriter \
        xsl \
        zip \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && pecl install mongodb && docker-php-ext-enable mongodb \
    && pecl install sqlsrv && docker-php-ext-enable sqlsrv \
    && pecl install pdo_sqlsrv && docker-php-ext-enable pdo_sqlsrv \
    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install amqp && docker-php-ext-enable amqp \
    && yes '' | pecl install imagick && docker-php-ext-enable imagick \
    && docker-php-source delete \
    && apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


# Enable all UTF-8 locales
RUN sed -i -E "s/#\ (.*)\.UTF-8(.*)/\1.UTF-8\2/" /etc/locale.gen && locale-gen
