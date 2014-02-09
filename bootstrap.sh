#!/usr/bin/env bash

# Get the updates
sudo apt-get update
sudo apt-get upgrade

# Get the necessary files
sudo apt-get install --assume-yes apache2 apache2-mpm-worker apache2-utils apache2.2-bin apache2.2-common libapr1 libaprutil1 libaprutil1-dbd-sqlite3 build-essential python3.2 python-dev libpython3.2 python3-minimal libapache2-mod-wsgi libaprutil1-ldap memcached python-cairo-dev python-django python-ldap python-memcache python-pysqlite2 sqlite3 erlang-os-mon erlang-snmp rabbitmq-server bzr expect libapache2-mod-python python-setuptools python-software-properties

# Grab important Python pieces
sudo easy_install django-tagging zope.interface twisted txamqp

# Grab Graphite files
cd ~
wget https://launchpad.net/graphite/0.9/0.9.10/+download/graphite-web-0.9.10.tar.gz
wget https://launchpad.net/graphite/0.9/0.9.10/+download/carbon-0.9.10.tar.gz
wget https://launchpad.net/graphite/0.9/0.9.10/+download/whisper-0.9.10.tar.gz

# Extract archives
find *.tar.gz -exec tar -zxvf '{}' \;

# Install whisper database
cd whisper*
sudo python setup.py install

# Install carbon
cd ../carbon*
sudo python setup.py install

# And Graphite
cd ../graphite*
sudo python check-dependencies.py
sudo python setup.py install

# Configure Graphite
cd /opt/graphite/conf
sudo cp carbon.conf.example carbon.conf

# Grab storage configuration
sudo cp /vagrant/storage-schemas.conf .
sudo cp /vagrant/storage-aggregation.conf .

# Manage graphite DB
cd /opt/graphite/webapp/graphite/
sudo python manage.py syncdb --noinput
# Yep - I know I shouldn't hardcode passwords - don't care today tho'
sudo python manage.py createsuperuser --username="root" --email="root@localhost.com" --noinput
sudo cp local_settings.py.example local_settings.py

# Configure Apache
sudo cp /opt/graphite*/examples/example-graphite-vhost.conf /etc/apache2/sites-available/default
sudo cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
sudo chown -R www-data:www-data /opt/graphite/storage
sudo mkdir -p /etc/httpd/wsgi
sudo sed -i"" "s/run\/wsgi/\/etc\/httpd\/wsgi/g" /etc/apache2/sites-available/default

sudo service apache2 restart

# Now for statsd
sudo apt-add-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install --assume-yes nodejs git
cd /opt
sudo git clone https://github.com/etsy/statsd.git
sudo cp /vagrant/localConfig.js /opt/statsd/
sudo /opt/graphite/bin/carbon-cache.py start
cd /opt/statsd
node ./stats.js ./localConfig.js

