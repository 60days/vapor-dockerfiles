FROM php:8.0-fpm-buster
 # changed from alpine

RUN apt-get update && \
    apt-get install -y \
    libmagickwand-dev \
    libonig-dev \
    libmcrypt-dev \
    libxml2-dev \
    zlib1g-dev \
    openssl \
    libssl-dev \
    libxml2-dev \
    libpq-dev \
    libpng-dev \
    libzip-dev \
    libxslt-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev && \
    # install imagick
    # use github version for now until release from https://pecl.php.net/get/imagick is ready for PHP 8
    mkdir -p /usr/src/php/ext/imagick; \
    curl -fsSL https://github.com/Imagick/imagick/archive/06116aa24b76edaf6b1693198f79e6c295eda8a9.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1; \
    docker-php-ext-install imagick; \
    docker-php-ext-enable imagick && \
    apt-get remove --purge -y automake autotools-dev bzip2-doc fontconfig gir1.2-freedesktop gir1.2-gdkpixbuf-2.0 gir1.2-glib-2.0 gir1.2-rsvg-2.0 icu-devtools javascript-common libblkid-dev libbz2-dev libcairo-gobject2 libcairo-script-interpreter2 libcairo2 libcairo2-dev libcroco3 libdatrie1 libdjvulibre-dev libdjvulibre-text libdjvulibre21 libelf1 libexif-dev libexif-doc libexif12 libexpat1-dev libffi-dev libfontconfig1-dev libfreetype6-dev libfribidi0 libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-bin libgdk-pixbuf2.0-common libgdk-pixbuf2.0-dev libgirepository-1.0-1 libglib2.0-bin libglib2.0-data libglib2.0-dev libglib2.0-dev-bin libgraphite2-3 libharfbuzz0b libice-dev libice6 libicu-dev libilmbase-dev libilmbase23 libjbig-dev libjpeg-dev libjpeg62-turbo-dev libjs-jquery libjxr-tools libjxr0 liblcms2-dev liblqr-1-0-dev libltdl-dev liblzma-dev liblzo2-2 libmagickcore-6-arch-config libmagickcore-6-headers libmagickcore-6.q16-6-extra libmagickcore-6.q16-dev libmagickwand-6-headers libmagickwand-6.q16-dev libmagickwand-dev libmount-dev libmpdec2 libopenexr-dev libopenexr23 libopenjp2-7-dev libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpcre16-3 libpcre3-dev libpcre32-3 libpcrecpp0v5 libpixman-1-0 libpixman-1-dev libpng-dev libpng-tools libpthread-stubs0-dev libpython3-stdlib libpython3.7-minimal libpython3.7-stdlib libreadline7 librsvg2-2 librsvg2-common librsvg2-dev libselinux1-dev libsepol1-dev libsm-dev libsm6 libthai-data libthai0 libtiff-dev libtiffxx5 libtool libwmf-dev libwmf0.2-7 libx11-dev libxau-dev libxcb-render0 libxcb-render0-dev libxcb-shm0 libxcb-shm0-dev libxcb1-dev libxdmcp-dev libxext-dev libxml2-dev libxrender-dev libxrender1 libxt-dev libxt6 mime-support python3 python3-distutils python3-lib2to3 python3-minimal python3.7 python3.7-minimal readline-common shared-mime-info uuid-dev x11-common x11proto-core-dev x11proto-dev x11proto-xext-dev xorg-sgml-doctools xtrans-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*


#Huge amount of alpine deps removed here - check original file https://github.com/laravel/vapor-dockerfiles/blob/master/php80.Dockerfile

RUN pecl channel-update pecl.php.net && \
    pecl install mcrypt redis-5.3.2 && \
    rm -rf /tmp/pear

RUN docker-php-ext-install \
    mysqli \
    mbstring \
    pdo \
    pdo_mysql \
    tokenizer \
    xml \
    pcntl \
    bcmath \
    pdo_pgsql \
    zip \
    intl \
    gettext \
    soap \
    sockets \
    xsl && \
    docker-php-ext-configure gd --with-freetype=/usr/lib/ --with-jpeg=/usr/lib/ && \
    docker-php-ext-install gd && \
    docker-php-ext-enable redis

#debian ssl dir
RUN cp /etc/ssl/certs/ca-certificates.crt /opt/cert.pem

COPY runtime/bootstrap /opt/bootstrap
COPY runtime/bootstrap.php /opt/bootstrap.php
COPY runtime/php.ini /usr/local/etc/php/php.ini

RUN chmod 755 /opt/bootstrap
RUN chmod 755 /opt/bootstrap.php

ENTRYPOINT []

CMD /opt/bootstrap
