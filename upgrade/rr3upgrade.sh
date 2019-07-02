#!/bin/bash

# This script can be use to upgrade Jagger Resource Registry,
# but it considers that Jagger Resource Registry and Codeigniter are installed into /opt directory

NOW=`date +%d-%m-%Y`
RR3_DB_USER='### RR3-DB-USER ###'
RR3_DB_USER_PW='### RR3-DB-USER-PASSWORD ###'

mysqldump --user=$RR3_DB_USER --password=$RR3_DB_USER_PW rr3 > /root/dumpRR3db.$NOW.sql
tar -czf /root/rr3.$NOW.tar.gz /opt/rr3
tar -czf /root/codeigniter.$NOW.tar.gz /opt/codeigniter

service apache2 stop

# If you come from a codeigniter branch before 3.0 version
# use this to change codeigniter branch to 3.0-stable:
# 
# cd /opt/codeigniter ; git checkout -b 3.0-stable origin/3.0-stable ; git pull
#
cd /opt/codeigniter ; git pull

cd /opt/rr3 ; git pull

/usr/local/bin/composer self-update

cd /opt/rr3/application ; composer update

./doctrine orm:schema-tool:update --force

./doctrine orm:generate-proxies

service apache2 start

service memcached restart

echo "Login on the web page https://registry.example.org/rr3/smanage/reports and follow steps presented"
