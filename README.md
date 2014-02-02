dockermail
==========

A simple mail server in a docker container.

This container uses postfix as MTA and dovecot as IMAP server. Only TLS/SSL-encrypted
connections are accepted. In theory it works with all mail clients, but
it was only tested with Thunderbird.

This is tailored to small private servers, where you own some domain(s) and
just want to receive the mail sent to this domain. 

Setup
=====


1) Add all domains you want to receive mail for to the file 'domains', like this:

    example.org
    example.net

2) Add user aliases to the file 'aliases', like

    johndoe@example.org	john.doe@example.org
    john.doe@example.org	john.doe@example.org
    admin@forum.example.org	forum-admin@example.org
    @example.net	catch-all@example.net

Only use simple adresses of the form <name>@<domain> on the right hand side.
A virtual mail account is created for each entry on the right hand side.

3) Add user passwords to the file 'passwords' like this

    john.doe@example.org:{PLAIN}password123
    admin@example.org:{SHA256-CRYPT}$5$ojXGqoxOAygN91er$VQD/8dDyCYOaLl2yLJlRFXgl.NSrB3seZGXBRMdZAr6

To get the hash values, you can run 'doveadm pw -s <scheme-name>' inside the container.

4) Build container

    docker build -t dockermail .

5) Run container and map ports 25 and 143 from the host to the container.
   To store your mail outside the container, map /srv/vmail/ to
   a directory on your host. (Its probably recommended to do that, otherwise
   you have to remember to backup you mail when you dont want to use the container anymore)

    docker run -d -p 0.0.0.0:25:25 -p 0.0.0.0:143:143 -v /mail/on/host:/srv/vmail:rw dockermail

6) Enjoy.


Known issues / Todo
=================
- It would be nice to have a way of catching mail to all subdomains.

- Changing any configuration requires rebuilding the image and restarting the container

- Also, a webmail frontend
