dockermail
==========

A mail server in a box.

A secure, minimal-configuration mail server in a docker container. 

This container uses postfix as MTA and dovecot as IMAP server. Only TLS/SSL-encrypted
connections are accepted. In theory it works with all mail clients, but
it was only tested with Thunderbird.

This is tailored to small private servers, where you own some domain(s) and
just want to receive the mail for and send mail from this domain. 

Setup
=====


1) Add all domains you want to receive mail for to the file `mail-base/domains`, like this:

    example.org
    example.net

2) Add user aliases to the file `mail-base/aliases`, like

    johndoe@example.org	john.doe@example.org
    john.doe@example.org	john.doe@example.org
    admin@forum.example.org	forum-admin@example.org
    @example.net	catch-all@example.net

An IMAP mail account is created for each entry on the right hand side.
Every mail sent to one of the addresses in the left column will
be delivered to the corresponding account in the right column.

3) Add user passwords to the file `mail-base/passwords` like this

    john.doe@example.org:{PLAIN}password123
    admin@example.org:{SHA256-CRYPT}$5$ojXGqoxOAygN91er$VQD/8dDyCYOaLl2yLJlRFXgl.NSrB3seZGXBRMdZAr6

To get the hash values, you can either install dovecot locally or use lxc-attach to attach to the running
container and run `doveadm pw -s <scheme-name>` inside.

4) Build base container

    cd mail-base
    docker build -t mail-base .

5) Build mail server container

    cd dovecot
    docker build -t dovecot:2.1.7 .

6) Run container and map ports 25 and 143 from the host to the container.
   To store your mail outside the container, map `/srv/vmail/` to
   a directory on your host. (This is recommended, otherwise
   you have to remember to backup your mail when you want to restart the container)

    docker run -d -p 0.0.0.0:25:25 -p 0.0.0.0:143:143 -v /mail/on/host:/srv/vmail:rw dockermail

7) Enjoy.


Known issues / Todo
===================
- It would be nice to have a way of catching mail to all subdomains.

- Changing any configuration requires rebuilding the image and restarting the container

- Also, a webmail frontend
