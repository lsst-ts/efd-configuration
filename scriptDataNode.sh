#Script to setup the data node

#Start the magagement node
sudo mkdir -p /var/lib/mysql-cluster/
sudo cp /home/vagrant/my.cnf_DataNode /etc/my.cnf
sudo ndbd --initial

