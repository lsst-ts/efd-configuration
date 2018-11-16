CPUS="1"
MEMORY="1024"

#VAGRANT_HOSTNAME="EFD-Mgmtnode-1"
#IPAddress="192.168.15.120"
#VAGRANT_HOSTNAME="EFD-Sqlnode-1"
#IPAddress="192.168.15.121"
#VAGRANT_HOSTNAME="EFD-Sqlnode-2"
#IPAddress="192.168.15.122"
#VAGRANT_HOSTNAME="EFD-Datanode-1"
#IPAddress="192.168.15.123"
#VAGRANT_HOSTNAME="EFD-Datanode-2"
#IPAddress="192.168.15.124"

nvme = './nvme-2.vdi'
hd1 = './hd1-2.vdi'
hd2 = './hd2-2.vdi'

$script = <<SCRIPT
#!/bin/bash

sudo mkfs.ext4 /dev/sdb
sudo mkfs.ext4 /dev/sdc
sudo mkfs.ext4 /dev/sdd
sudo mkdir /mnt/tier1
sudo mkdir /mnt/tier2
sudo mkdir /mnt/tier3
sudo mount -o nobarrier /dev/sdb /mnt/tier1
sudo mount -o nobarrier /dev/sdc /mnt/tier2
sudo mount -o nobarrier /dev/sdd /mnt/tier3

#instructions from howtoforge: https://www.howtoforge.com/tutorial/how-to-install-and-configure-mysql-cluster-on-centos-7/
#MySql cluster installation:
cd /home/vagrant/Downloads/MySQL-Cluster
tar -xvf mysql-cluster-community-7.6.8-1.el7.x86_64.rpm-bundle.tar

#Installing - removing packages 
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm #add additional packages
sudo yum -y install perl-Data-Dumper
sudo yum -y remove mariadb-libs

#Install MySQL Cluster
sudo yum -y install mysql-cluster-community-common-7.6.8-1.el7.x86_64.rpm
sudo yum -y install mysql-cluster-community-libs-7.6.8-1.el7.x86_64.rpm
sudo yum -y install mysql-cluster-community-client-7.6.8-1.el7.x86_64.rpm #This only applied to server node
sudo yum -y install mysql-cluster-community-server-7.6.8-1.el7.x86_64.rpm #This only applied to server node
sudo yum -y install mysql-cluster-community-management-server-7.6.8-1.el7.x86_64.rpm #This only applied to management nodes
sudo yum -y install mysql-cluster-community-data-node-7.6.8-1.el7.x86_64.rpm #This only applied to data nodes

sudo chown -R vagrant:vagrant *

#sudo setenforce 0 #had to setup to make it work....
# SELinux configuration to permits the database server to communicate to the cluster
sudo yum -y install policycoreutils-python-2.5-22.el7.x86_64
sudo semanage permissive -a mysqld_t
sudo semanage port -a -t mysqld_port_t -p tcp 4567
sudo semanage port -a -t mysqld_port_t -p tcp 4568
sudo semanage port -a -t mysqld_port_t -p tcp 4444
sudo semanage port -a -t mysqld_port_t -p udp 4567

#cd /home/vagrant
#sh /home/vagrant/script.sh

SCRIPT

Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.hostname = VAGRANT_HOSTNAME
  config.vm.network "private_network", ip: IPAddress
  config.vm.provider "virtualbox" do |v|
    v.name = VAGRANT_HOSTNAME
    v.memory = MEMORY
    if not File.exists?(nvme)
      v.customize ['createhd', '--filename', nvme, '--variant', 'Fixed', '--size', 10 * 1024]
    end
    if not File.exists?(hd1)
      v.customize ['createhd', '--filename', hd1, '--variant', 'Fixed', '--size', 10 * 1024]
    end
    if not File.exists?(hd2)
      v.customize ['createhd', '--filename', hd2, '--variant', 'Fixed', '--size', 10 * 1024]
    end
    v.customize ['storagectl', :id, '--name', 'SATA Controller', '--add', 'sata', '--portcount', 3]
    v.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', nvme]
    v.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', hd1]
    v.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', hd2]
    
    v.cpus = CPUS
  end
  config.vm.provision "file", source: "../mysql-cluster-community-7.6.8-1.el7.x86_64.rpm-bundle.tar", destination: "/home/vagrant/Downloads/MySQL-Cluster/mysql-cluster-community-7.6.8-1.el7.x86_64.rpm-bundle.tar"
  config.vm.provision "file", source: "../config.ini", destination: "/home/vagrant/config.ini"
  config.vm.provision "file", source: "../my.cnf_DataNode", destination: "/home/vagrant/my.cnf_DataNode"
  config.vm.provision "file", source: "../my.cnf_SqlNode", destination: "/home/vagrant/my.cnf_SqlNode"
  config.vm.provision "file", source: "../scriptDataNode.sh", destination: "/home/vagrant/scriptDataNode.sh"
  config.vm.provision "file", source: "../scriptMgmtNode.sh", destination: "/home/vagrant/scriptMgmtNode.sh"
  config.vm.provision "file", source: "../scriptSqlNode.sh", destination: "/home/vagrant/scriptSqlNode.sh"
  config.vm.provision "shell" do |s|
     s.inline = $script
  end


end

