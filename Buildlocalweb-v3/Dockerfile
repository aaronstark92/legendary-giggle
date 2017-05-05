# This Dockerfile uses dbuild for consistent builds.
# https://bitbucket.org/ebsv/docker-build
#
# START PRE-BUILD
#
# # Image repository name
# #
# REPOSITORY="aaronstark/buildlocalweb-v3"
#
# # Image tag
# #
# TAG="$(date +%s)"
#
# # Perform other pre-build steps here
#
# END PRE-BUILD

FROM php:7.0-fpm
MAINTAINER asisk@starkartthenala.com

# [s6-overlay]
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

# [CONCRETE VERSION & SOURCE]
ENV CONCRETE_VERSION 5.7.5.13
ENV C5_URL http://www.concrete5.org/download_file/-/view/93075/
ENV C5_HOME /var/www/html

# [Environment]
ARG DEBIAN_FRONTEND=noninteractive
ENV TERM        xterm
ENV NPROC       grep -c ^processor /proc/cpuinfo

# Config
COPY apps/config/php/php.ini /usr/local/etc/php/

# Dependencies
RUN apt-get update \
        && apt-get -y install \
        unzip \
        #gd dependencies
        libpng12-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        # curl dependencies
        libcurl4-gnutls-dev \
        # mcrypt dependencies
        libmcrypt-dev \
        # xml dependencies
        libxml2-dev \
        # openssl dependencies
        libssl-dev \
        vim

# Extensions
RUN docker-php-source extract \
 && cp /usr/src/php/ext/openssl/config0.m4 /usr/src/php/ext/openssl/config.m4 \
 && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
 && docker-php-ext-install  -j$(nproc) \
        gd \
        zip \
        xml \
        curl \
        mbstring \
        mysqli \
        pdo_mysql \
        openssl \
        opcache \
  && pecl install \
        apcu \
  && docker-php-ext-enable \
        apcu

# Config
RUN ln -s /usr/local/etc/php /etc/php
COPY apps/config/php/php.ini /etc/php/

# FastCGI
RUN ln -sf /dev/stderr /var/log/php-fpm.log
COPY apps/config/php/php7-fpm.conf /usr/local/etc/php/php-fpm.conf
COPY apps/config/php/pool.conf /usr/local/etc/php/php-fpm.d/www.conf

#  [Apt Cleanup]
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists

#  [Concrete5]
ADD $C5_URL /tmp/concrete5.zip
RUN cd /tmp \
 && unzip /tmp/concrete5.zip \
 && rm /tmp/concrete5.zip


# s6 Process Manager Config
COPY apps/s6-overlay/services.d /etc/services.d
COPY apps/s6-overlay/cont-init.d /etc/cont-init.d

WORKDIR /var/www/html
ENTRYPOINT ["/init"]
