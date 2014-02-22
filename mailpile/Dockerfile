FROM mail-base

RUN apt-get update
RUN apt-get -y --force-yes install git make gettext

RUN git clone -b 0.1.0 --depth=1 https://github.com/pagekite/Mailpile.git /etc/mailpile

# mailpile dependencies
RUN apt-get install -y --force-yes python-imaging python-lxml python-jinja2 pep8 rubygems ruby-dev yui-compressor python-nose spambayes

RUN cd /etc/mailpile; make debian-dev

RUN cd /etc/mailpile; ./mp --setup; ./mp --set sys.http_host=0.0.0.0

ENTRYPOINT /etc/mailpile/mp --www


# installation instructions at
# https://github.com/pagekite/Mailpile/wiki/Getting-started
