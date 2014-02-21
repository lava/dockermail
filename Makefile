all: base dovecot

.PHONY: base dovecot run

base: 
	cd mail-base; docker build -t mail-base .

dovecot: 
	cd dovecot; docker build -t dovector:2.1.7 .

run:
	docker run -d -p 0.0.0.0:25:25 -p 0.0.0.0:587:587 -p 0.0.0.0:143:143 -v /srv/vmail:/srv/vmail dovecot:2.1.7
