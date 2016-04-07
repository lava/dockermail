FROM mail-base

RUN apt-get update \
    && apt-get install -y --force-yes \
        wget                \
        unzip               \
        apache2             \
        php5                \
        libapache2-mod-php5 \
        php5-curl           \
        php5-json           \
    && rm -rf /var/lib/apt/lists/*

RUN wget -P /var/www http://repository.rainloop.net/v2/webmail/rainloop-community-latest.zip
RUN unzip -d /var/www/ /var/www/rainloop-community-latest.zip

# Force initialization of data directories triggered at first program start
RUN php /var/www/index.php

ADD ./create_config.sh /create_config.sh
RUN bash ./create_config.sh
RUN cp -r /var/www/rainloop /var/www/html           \
    && cp -r /var/www/data /var/www/html            \
    && cp /var/www/index.php /var/www/html/index.php\
    && chown -R www-data:www-data /var/www

ENTRYPOINT apachectl -DFOREGROUND
