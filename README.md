dockermail
==========

A mail server in a box.

A secure, minimal-configuration mail server in a docker container, including webmail.

This repository is tailored to small private servers, where you own some domain(s) and
want to receive the mail for and send mail from this domain. It consists of 4 separate docker containers:

 - **dovecot**:  The SMTP and IMAP server. This container uses postfix as MTA and dovecot as IMAP server.
    All incoming mail to your own domains is accepted. For outgoing mail, only authenticated (logged in with username and password)
    clients can send messages via STARTTLS on port 587. In theory it works with all mail clients, but it was only tested with Thunderbird.

 - **rainloop**: An automatically configured webmail interface. Note that you have to login with your full mail adress, 
   e.g. `john.doe@example.org` instead of just `john.doe`. By default, this will bind to `localhost:33100`.

   There is a webmail admin interface available at `localhost:33100/?admin` with
   default username `admin` and default password `12345`, so you probably want to change that before connecting this container to
   the internet. Note that just knowing the admin password isnt enough for other people to read your mail, since the mail password
   isn't stored within rainloop. Also note that the admin 
   password will reset to the default values every time you restart the container.
    
   Rainloop is released under CC BY-NC-SA 3.0, so you are only allowed to use this container for non-commercial purposes. They do
   sell commercial licenses, if required.

 - **owncloud**: This provides CalDAV and CardDAV functionality, together with tons and tons of other stuff like cloud storage,
   collaborative editing, etc. You should be able to login using your mail address automatically.

   By default, this container will bind to `localhost:33200`.
   All user data is by default mapped `/srv/owncloud` on the host.
   As above, the default admin account has username `admin` and password `12345`, so make sure to change this before connecting the container to the internet.
   
   It is also possible to install a webmail interface within owncloud, so in theory you don't need rainloop.
   That said, restarting the container after configuration changes
   can be a bit rough and might require manual intervention so if you *just* want webmail, rainloop is probably preferrable.
   If you encounter problems, try deleting `/srv/owncloud/owncloud.db` and restarting the container.

 - **mailpile**: An early-alpha but promising webmail interface. It is currently not built by default, 
   but you can play around with it if you like. By default, the web interface will bind to `localhost:33411`


 - **mail-base**: This image is just an implementation detail. It is a workaround to allow sharing of configuration files between multiple docker images. 



Setup
=====


1) Add all domains you want to receive mail for to the file `mail-base/domains`, like this:

    example.org
    example.net

2) Add user aliases to the file `mail-base/aliases`, like

    johndoe@example.org	        john.doe@example.org
    john.doe@example.org        john.doe@example.org
    admin@forum.example.org     forum-admin@example.org
    @example.net	        catch-all@example.net

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

You can build single targets, so if you dont want the webmail you can just run `make dovecot` instead. The Makefile is
extremely simple, dont be afraid to look inside.

6) Run container and map ports 25 and 143 from the host to the container.
   To store your mail outside the container, map `/srv/vmail/` to
   a directory on your host. (This is recommended, otherwise
   you have to remember to backup your mail when you want to restart the container)
   This is done automaticaly by

    make run-all

   Again, you can make `run-dovecot` or `run-rainloop` to only start specific containers. Look 
   at the Makefile to see what this does exactly. Note that you have to stop old containers
   manually before invoking make, as this currently cannot be done automatically.

7) (Optional) If you want to use owncloud, enter the public url at which owncloud can be reached (e.g. `owncloud.example.org`) into the file `owncloud/public_url`.

8) Enjoy.


Known issues / Todo / Wishlist
==============================
- HELO isn't set correctly, which can lead to problems with outgoing mail on some servers

- It would be nice to have a way of catching mail to all subdomains.

- Changing any configuration requires rebuilding the image and restarting the container

- The Makefile currently cannot stop/replace old containers automatically

Patches welcome!
