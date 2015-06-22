#!/usr/bin/env bash

sudo apt-get update >> /dev/null 2>&1

# install tools necessary to build Ambari
dpkg -l |  awk '{print $2}' | grep "make" >> /dev/null 2>&1
if [ $? -ne 0 ];
then
    sudo apt-get install ntp wget -y
    sudo service ntp start
else
    echo "ntp is already installed"
fi

# install tools necessary to build Ambari
dpkg -l |  awk '{print $2}' | grep "make" >> /dev/null 2>&1
if [ $? -ne 0 ];
then
    sudo apt-get install make -y
else
    echo "make package already present"
fi

dpkg -l |  awk '{print $2}' | grep "g++" >> /dev/null 2>&1
if [ $? -ne 0 ];
then
    sudo apt-get install g++ -y
else
    echo " g++ package already present"
fi

dpkg -l |  awk '{print $2}' | grep "git" >> /dev/null 2>&1
if [ $? -ne 0 ];
then
    sudo apt-get install git -y
else
    echo "git package already present"
fi

#java
dpkg -l |  awk '{print $2}' | grep "openjdk-7-jdk" >> /dev/null 2>&1
if [ $? -ne 0 ];
then
    sudo apt-get install openjdk-7-jdk -y
else
    echo "openjdk already installed"
fi

#node
node --version | grep "v0.10.31" >> /dev/null 2>&1
if [ $? -ne 0 ];
then
    wget http://nodejs.org/dist/v0.10.31/node-v0.10.31-linux-x64.tar.gz
    tar zxvf node-v0.10.31-linux-x64.tar.gz
    sudo mv node-v0.10.31-linux-x64 /usr/share/node
    sudo /usr/share/node/bin/npm install -g brunch
    sudo echo 'PATH=$PATH:/usr/share/node/bin' > /etc/profile.d/node.sh
    sudo chmod +x /etc/profile.d/node.sh
else
    echo "node already present"
fi

#maven
mvn --version | grep "3.0.5" >> /dev/null 2>&1
if [ $? -ne 0 ];
then
    wget http://psg.mtu.edu/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
    tar zxvf apache-maven-3.0.5-bin.tar.gz
    sudo mv apache-maven-3.0.5 /usr/share/maven
    sudo echo 'PATH=$PATH:/usr/share/maven/bin' > /etc/profile.d/maven.sh
    sudo chmod +x /etc/profile.d/maven.sh
else
    echo "mvn already present"
fi

# install and configure docker
docker --version | grep "1.7.0" >> /dev/null 2>&1
if [ $? -ne 0 ];
then
    wget -qO- https://get.docker.com/ | sh
    sudo usermod -aG docker vagrant
    sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/g' /etc/default/grub
    sudo update-grub
    sudo sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw
    sudo ufw reload
    sudo ufw allow 2375/tcp
    sudo echo 'DOCKER_OPTS="--dns 192.168.67.2 --dns 8.8.8.8"' >> /etc/default/docker
    sudo service docker stop
    sudo service docker start
else
    echo "Docker already installed"
fi



