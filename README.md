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

4) Build containers:

    make

You can build single targets with `make dovecot`, `make rainloop`, etc. The Makefile is
extremely simple, so you can just look inside for more information.

6) Run container and map ports 25 and 143 from the host to the container.
   To store your mail outside the container, map `/srv/vmail/` to
   a directory on your host. (This is recommended, otherwise
   you have to remember to backup your mail when you want to restart the container)
   This is done automaticaly by

    make run-all

   Again, you can make `run-dovecot` or `run-rainloop` to only start specific containers. Look 
   at the Makefile to see what this does exactly.

7) Enjoy. The webmail frontend lives in a container called rainloop and is reachable at `localhost:33100`. 
   To access this from the web, you can either point a reverse proxy on the host to this adress or change the 
   `docker run` command to connect this directly to the hosts port 80.

Note that there is a webmail admin interface available at `localhost:33100/?admin with
username 'admin' and password '12345', so  *DONT CONNECT THE RAINLOOP CONTAINER TO THE INTERNET
UNTIL YOU HAVE CHANGED THIS*. Also note that the admin account will *RESET EVERY TIME YOU RESTART THE RAINLOOP CONTAINER*. 

Considering that rainloop is a php application, you might not
want to expose it directly to the internet at all. Then again, even if an attacker can
exploit rainloop, its still not easy to escape from the docker container.


Known issues / Todo
===================
- It would be nice to have a way of catching mail to all subdomains.

- Changing any configuration requires rebuilding the image and restarting the container
