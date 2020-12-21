FROM php:7.2.4-fpm

RUN apt-get update && apt-get install -y \
        apt-utils \
        supervisor \
        nginx \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        wget \
        procps \
        libsqlite3-dev \
        zlib1g-dev \
        libxml2-dev \
    && docker-php-ext-install pdo_mysql mysqli gd json zip opcache \ 
    && docker-php-ext-install soap

RUN apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

RUN adduser --system --no-create-home --shell /bin/false --group --disabled-login nginx

ADD docker/supervisord.conf /etc/supervisord.conf
ADD docker/default.conf /etc/nginx/sites-enabled/default
ADD docker/www.conf /usr/local/etc/php-fpm.d/www.conf
ADD docker/start.sh /start.sh

RUN chmod a+x /start.sh

EXPOSE 443 80

CMD ["/start.sh"]
