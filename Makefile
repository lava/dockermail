DOVECOT_VERSION = dovecot:2.1.7
RAINLOOP_VERSION = rainloop:1.9.4
MAILPILE_VERSION = mailpile:latest
OWNCLOUD_VERSION = owncloud:8.0.2

all: mail-base dovecot rainloop owncloud

.PHONY: mail-base dovecot rainloop owncloud run-dovecot run-rainloop run-owncloud

mail-base:
	cd mail-base; docker build --no-cache -t mail-base .

dovecot: mail-base
	cd dovecot; docker build -t $(DOVECOT_VERSION) .

rainloop: dovecot
	cd rainloop; docker build -t $(RAINLOOP_VERSION) .

mailpile: dovecot
	cd mailpile; docker build -t $(MAILPILE_VERSION) .

owncloud: dovecot
	cd owncloud; docker build -t $(OWNCLOUD_VERSION) .

run-dovecot:
	- docker stop dockermail-dovecot;
	- docker rm dockermail-dovecot;
	- docker run -d -p 0.0.0.0:25:25 -p 0.0.0.0:587:587 -p 0.0.0.0:143:143 --name dockermail-dovecot -v /srv/vmail:/srv/vmail $(DOVECOT_VERSION)

run-rainloop:
	- docker stop dockermail-rainloop;
	- docker rm dockermail-rainloop;
	- docker run -d -p 127.0.0.1:33100:80 --name dockermail-rainloop $(RAINLOOP_VERSION)

run-mailpile:
	- docker stop dockermail-mailpile;
	- docker rm dockermail-mailpile;
	- docker run -d -p 127.0.0.1:33411:33411 --name dockermail-mailpile $(MAILPILE_VERSION)

run-owncloud:
	- docker stop dockermail-owncloud;
	- docker rm dockermail-owncloud;
	- docker run -d -p 127.0.0.1:33200:80 --name dockermail-owncloud  -v /srv/owncloud:/var/www/owncloud/data ($OWNCLOUD_VERSION)

run-all: run-dovecot run-rainloop run-owncloud

save-dovecot: dovecot
	- docker save -o dovecot.docker $(DOVECOT_VERSION)

save-rainloop: rainloop
	- docker save -o rainloop.docker $(RAINLOOP_VERSION)

save-owncloud: owncloud
	- docker save -o owncloud.docker $(OWNCLOUD_VERSION)

save-mailpile: mailpile
	- docker save -o mailpile.docker $(MAILPILE_VERSION)

save-all: save-dovecot save-rainloop save-owncloud save-mailpile
