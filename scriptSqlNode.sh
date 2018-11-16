#Script to setup the sql node

#Start the magagement node
sudo mkdir -p /var/lib/mysql-cluster/
sudo cp /home/vagrant/my.cnf_SqlNode /etc/my.cnf
sudo service mysqld start 

