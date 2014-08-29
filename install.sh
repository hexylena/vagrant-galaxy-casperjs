#!/bin/bash
wget --no-clobber https://bitbucket.org/galaxy/galaxy-dist/get/latest_2014.08.11.tar.gz -O /tmp/latest_2014.08.11.tar.gz
cd /home/vagrant/
if [ ! -d "galaxy" ];
then
    tar xvfz /tmp/latest_2014.08.11.tar.gz
    mv galaxy-galaxy-dist-0047ee06fef0 galaxy
    chown vagrant: -R /home/vagrant/galaxy/
fi
cd galaxy
# Don't care that it exits one
result=$(sh run.sh --stop-daemon)
cp /vagrant/galaxy/* /home/vagrant/galaxy/
apt-get install -y uwsgi uwsgi-plugin-python supervisor nginx python-virtualenv
sudo update-rc.d -f uwsgi remove
if [ ! -d "/home/vagrant/venv" ];
then
    virtualenv /home/vagrant/venv/
fi
chown vagrant: -R /home/vagrant/

cp /vagrant/index.html /usr/share/nginx/html/index.html
cp /vagrant/nginx.conf /etc/nginx/sites-enabled/default
cp /vagrant/supervisor.conf /etc/supervisor/conf.d/galaxy.conf
service nginx restart
service supervisor restart
