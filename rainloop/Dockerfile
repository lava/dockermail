FROM mail-base

RUN apt-get install -y --force-yes git

RUN git clone https://github.com/RainLoop/rainloop-webmail.git /var/www

# The rainloop project seems to have given up on versioning.
# The following commit is master from March 2, 2016
RUN cd /var/www && git checkout -b dockermail 5eb9bd311a5f3314daf97d8acc3b7b354996d26c

RUN apt-get install -y --force-yes apache2 php5 libapache2-mod-php5 php5-curl php5-json

# Force initialization of data directories triggered at first program start
RUN php /var/www/index.php

RUN chown -R www-data:www-data /var/www

ADD ./create_config.sh /create_config.sh

RUN bash ./create_config.sh

RUN cp -r /var/www/rainloop /var/www/html
RUN cp -r /var/www/data /var/www/html
RUN cp /var/www/index.php /var/www/html/index.php

ENTRYPOINT apachectl -DFOREGROUND
