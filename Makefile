all: mail-base dovecot rainloop

.PHONY: mail-base dovecot rainloop run-dovecot run-rainloop

mail-base: 
	cd mail-base; docker build -t mail-base .

dovecot: mail-base
	cd dovecot; docker build -t dovector:2.1.7 .

rainloop: mail-base
	cd rainloop; docker build -t rainloop:1.6.1 .

run-dovecot:
	docker run -d -p 0.0.0.0:25:25 -p 0.0.0.0:587:587 -p 0.0.0.0:143:143 -v /srv/vmail:/srv/vmail dovecot:2.1.7

run-rainloop:
	docker run -d -p 127.0.0.1:33100:80 rainloop:1.6.1

run-all: run-dovecot run-rainloop
