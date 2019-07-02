#!/bin/bash

RR3_DB_USER='### RR3-DB-USER ###'
RR3_DB_USER_PW='### RR3-DB-USER-PASSWORD ###'

echo "Show which Registry backups are available: "
ls -l /root | grep rr3

echo "Select the Registry backup do you want to restore by digiting its name and press [ENTER]: "
read rr3backup

echo "Show which Codeigniter backups are available: "
ls -l /root | grep codeigniter

echo "Select the Codeigniter backup do you want to restore by digiting its name and press [ENTER]: "
read codeigniter

echo "... Restoring '/opt/rr3' directory ..."
cd /
tar -xzf /root/$rr3backup

echo "... Restoring '/opt/codeigniter' directory ..."
cd /
tar -xzf /root/$codeigniter

echo "Show which Registry DB backups are available: "
ls -l /root

echo "Select the Registry DB backup do you want to restore by digiting its name and press [ENTER]: "
read rr3DB

echo "... Restoring 'rr3' DB ..."
mysql --user=$RR3_DB_USER --password=$RR3_DB_USER_PW rr3 < /root/$rr3DB

cd /opt/rr3/application
./doctrine orm:schema-tool:update --force
./doctrine orm:generate-proxies

service apache2 restart

service memcached restart

echo "Login on the web page https://registry.example.org/rr3/smanage/reports and follow steps presented"
