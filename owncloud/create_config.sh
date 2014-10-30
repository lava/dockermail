PUBLIC_URL=`cat /public_url`
CONFIGFILE=/var/www/owncloud/config/config.php

echo "<?php
\$CONFIG = array(

'overwritehost' => '$PUBLIC_URL',
'check_for_working_webdav' => false,
'dbtype' => 'sqlite',

'user_backends'=>array(
	array(
		'class' => 'OC_User_IMAP',
		'arguments' => array( " > $CONFIGFILE

for domain in $(cat /domains); do
	echo "			'{$domain:143/imap/tls/novalidate-cert}INBOX'," >> $CONFIGFILE
done

echo "
		)
	)
) 

); " >> $CONFIGFILE

