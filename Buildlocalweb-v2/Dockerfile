# This Dockerfile uses dbuild for consistent builds.
# https://bitbucket.org/ebsv/docker-build
#
# START PRE-BUILD
#
# # Image repository name
# #
# REPOSITORY="aaronstark/buildlocalweb-v2"
#
# # Image tag
# #
# TAG="$(date +%s)"
#
# # Perform other pre-build steps here
#
# END PRE-BUILD
FROM php:7.1-apache
MAINTAINER asisk@starkartthenala.com

# [Environment]
ARG DEBIAN_FRONTEND=noninteractive
ENV TERM        xterm
ENV NPROC       grep -c ^processor /proc/cpuinfo

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
        vim \
        # [Apt Cleanup]
        && apt-get clean && rm -r /var/lib/apt/lists/*

# Extensions
RUN docker-php-source extract \
 && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
 && docker-php-ext-install gd \
        curl \
        mbstring \
        mysqli \
        pdo_mysql

# [s6-overlay]
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

# [CONCRETE VERSION & SOURCE]
ENV CONCRETE_VERSION 5.7.5.13
ENV C5_URL http://www.concrete5.org/download_file/-/view/93075/

#  [Concrete5]
RUN cd /usr/local/src \
        && curl -o concrete5.zip -SL $C5_URL \
        && unzip concrete5.zip \
        && rm -v concrete5.zip \
        && cp -r /usr/local/src/concrete$CONCRETE_VERSION/* /var/www/html \
        && cp && chmod -Rv 777 /var/www/html/* \
        && chown -Rv root:www-data /var/www/html/*

# s6 Process Manager Config
COPY apps/s6-overlay/cont-init.d /etc/cont-init.d
COPY apps/s6-overlay/services.d /etc/services.d

WORKDIR /var/www/html
ENTRYPOINT ["/init"]
