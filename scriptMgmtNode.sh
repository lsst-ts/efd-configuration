#Script to setup the management node

#Start the magagement node
sudo mkdir -p /var/lib/mysql-cluster 
sudo cp /home/vagrant/config.ini /var/lib/mysql-cluster/config.ini
ndb_mgmd --config-file=/var/lib/mysql-cluster/config.ini --initial

