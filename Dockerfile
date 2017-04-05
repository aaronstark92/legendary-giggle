# Do we have a specific apache image?
FROM chriswayg/apache-php
MAINTAINER asisk@starkartthenala.com

RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get -y install \
        apt-utils \
        unzip \
        vim \
        curl \
        php5-mysql && \
    apt-get clean && rm -r /var/lib/apt/lists/*

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

ENV CONCRETE_VERSION 5.7.5.13
ENV C5_URL http://www.concrete5.org/download_file/-/view/93075/
ENV TERM xterm

RUN cd /usr/local/src \
        && curl -o concrete5.zip -SL $C5_URL \
        && unzip concrete5.zip \
        && rm -v concrete5.zip \
        && rm -v /var/www/html/index.html \
        && cp -r /usr/local/src/concrete$CONCRETE_VERSION/* /var/www/html \
        && chmod -Rv 777 /var/www/html/* \
        && chown -Rv root:www-data /var/www/html/*

WORKDIR /var/www/html

CMD ["apache2-foreground"]
