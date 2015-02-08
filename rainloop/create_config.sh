DIR=`ls /var/www/data/_data_* -d`
for i in $(cat /domains);
 do echo "\
imap_host = \"$i\" 
imap_port = 143
imap_secure = \"TLS\"
smtp_host = \"$i\"
smtp_port = 587
smtp_secure = \"TLS\"
smtp_auth = On" > $DIR/_default_/domains/$i.ini;
done;
