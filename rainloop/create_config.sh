DIR=`ls /var/www/data/_data_* -d`
for i in $(cat /domains);
 do echo "\
imap_host = \"$i\" 
imap_port = 143
imap_secure = \"TLS\"
smpt_host = \"$i\"
smpt_port = 587
smpt_secure = \"TLS\"
smpt_auth = On" > $DIR/_default_/domains/$i.ini;
done;
