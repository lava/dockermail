FROM mail-base

RUN apt-get -y update \
    && apt-get install -y --force-yes wget apache2 sqlite3 libapache2-mod-php5  \
        php5-gd php5-json php5-mysql php5-curl php5-sqlite php5-imap               \
        php5-intl php5-mcrypt php5-imagick                                         \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://download.owncloud.org/community/owncloud-8.2.3.tar.bz2  \
    && tar -xvf owncloud-8.2.3.tar.bz2 --directory /var/www/ #--strip-components=1

# Generate data directory etc.
ADD ./create_config.sh /create_config.sh
ADD ./public_url /public_url
ADD ./autoconfig.php /var/www/owncloud/config/autoconfig.php
RUN /create_config.sh
RUN mkdir /var/www/owncloud/data
RUN chown -R www-data:www-data /var/www/owncloud

RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD ./001-owncloud.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/001-owncloud.conf /etc/apache2/sites-enabled/

RUN cd /var/www/owncloud/ && sudo -u www-data php5 index.php
RUN php5 /var/www/owncloud/occ app:enable user_external
RUN cp -pr /var/www/owncloud/data /owncloud_bootstrap

ENTRYPOINT cp -npr /owncloud_bootstrap/. /var/www/owncloud/data \
    && chown -R www-data:www-data /var/www/owncloud/data        \
    && a2enmod rewrite                                          \
    && php5enmod imap                                           \
    && apachectl -DFOREGROUND
