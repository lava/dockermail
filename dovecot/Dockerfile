FROM mail-base

# prerequisites
RUN apt-get update                                  \
    # install self-signed ssl certs
    && apt-get install -y --force-yes ssl-cert      \
    # Install postfix as MTA
    postfix       \
    # Install postgrey for greylisting
    postgrey      \
    # Install dovecot as IMAP server
    dovecot-imapd \
    && rm -rf /var/lib/apt/lists/*

# postfix configuration
RUN echo "mail.docker.container" > /etc/mailname
ADD ./postfix.main.cf /etc/postfix/main.cf
ADD ./postfix.master.cf.append /etc/postfix/master-additional.cf
RUN cat /etc/postfix/master-additional.cf >> /etc/postfix/master.cf

# configure mail delivery to dovecot
#ADD ./aliases /etc/postfix/virtual
#ADD ./domains /etc/postfix/virtual-mailbox-domains
RUN cp /aliases /etc/postfix/virtual                     \
    && cp /domains /etc/postfix/virtual-mailbox-domains

# todo: this could probably be done in one line
RUN mkdir /etc/postfix/tmp                                                                                                    \
    && awk < /etc/postfix/virtual '{ print $2 }' > /etc/postfix/tmp/virtual-receivers                                         \
    && sed -r 's,(.+)@(.+),\2/\1/,' /etc/postfix/tmp/virtual-receivers > /etc/postfix/tmp/virtual-receiver-folders            \
    && paste /etc/postfix/tmp/virtual-receivers /etc/postfix/tmp/virtual-receiver-folders > /etc/postfix/virtual-mailbox-maps

# map virtual aliases and user/filesystem mappings
RUN postmap /etc/postfix/virtual              \
    && postmap /etc/postfix/virtual-mailbox-maps

# add user vmail who own all mail folders
RUN groupadd -g 5000 vmail                             \
    && useradd -g vmail -u 5000 vmail -d /srv/vmail -m \
    && chown -R vmail:vmail /srv/vmail                 \
    && chmod u+w /srv/vmail

# dovecot configuration
ADD ./dovecot.mail /etc/dovecot/conf.d/10-mail.conf
ADD ./dovecot.ssl /etc/dovecot/conf.d/10-ssl.conf
ADD ./dovecot.auth /etc/dovecot/conf.d/10-auth.conf
ADD ./dovecot.master /etc/dovecot/conf.d/10-master.conf
ADD ./dovecot.lda /etc/dovecot/conf.d/15-lda.conf
ADD ./dovecot.imap /etc/dovecot/conf.d/20-imap.conf
# add verbose logging
#ADD ./internal/dovecot.logging /etc/dovecot/conf.d/10-logging.conf

# Add password file
RUN cp /passwords /etc/dovecot/passwd

# i'm not sure what expose actually does, so its mainly here for documentation
# smtp port for incoming mail
EXPOSE 25
# imap port
EXPOSE 143
# smtp port for outgoing
EXPOSE 587

# todo: enable port 587 for outgoing mail, separate ports 25 and 587
# http://www.synology-wiki.de/index.php/Zusaetzliche_Ports_fuer_Postfix

# start necessary services for operation (dovecot -F starts dovecot in the foreground to prevent container exit)
ENTRYPOINT chown -R vmail:vmail /srv/vmail; service rsyslog start; service postgrey start; service postfix start; dovecot -F

