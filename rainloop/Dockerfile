FROM mail-base

RUN apt-get install -y --force-yes git

# newer git versions (>1.7.3) can use 
#    git clone -b 1.6.9 --depth 1 [...]
# to get a shallow copy of the specific release tag
RUN git clone https://github.com/RainLoop/rainloop-webmail.git /var/www
RUN cd /var/www && git checkout tags/1.6.9

RUN apt-get install -y --force-yes apache2 php5 libapache2-mod-php5 php5-curl php5-json

# Force initialization of data directories triggered at first program start
RUN php /var/www/index.php

RUN chown -R www-data:www-data /var/www

ADD ./create_config.sh /create_config.sh

RUN bash ./create_config.sh

ENTRYPOINT apachectl -DFOREGROUND
