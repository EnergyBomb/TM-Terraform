#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'secret'";
echo s/127.0.0.1/10.0.1.100/g >> sed.sed
sudo sed -f sed.sed /etc/mysql/mysql.conf.d/mysqld.cnf -i
systemctl restart mysql


sudo mysql -u root -psecret -e "CREATE USER 'remote'@'%' IDENTIFIED BY 'remote';" >> /home/ubuntu/mysql.sh
sudo mysql -u root -psecret -e  "GRANT ALL PRIVILEGES ON *.* TO 'remote'@'%' WITH GRANT OPTION;" >> /home/ubuntu/mysql.sh
sudo mysql -u root -psecret -e  "FLUSH PRIVILEGES;" >> /home/ubuntu/mysql.sh

sudo mysql -u root -psecret -e "CREATE DATABASE IF NOT EXISTS files;"
sleep 10
sudo mysql -u root -psecret -e "USE files; CREATE TABLE IF NOT EXISTS file (name VARCHAR(255) PRIMARY KEY);"
