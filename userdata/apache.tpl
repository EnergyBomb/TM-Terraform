#!/bin/bash
sudo apt update
sudo apt-get install -y apache2
sudo systemctl start apache2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
sudo unzip awscliv2.zip
sudo ./aws/install
sudo apt install mysql-client -y

sudo rm /var/www/html/index.html
sudo aws s3 sync s3://tm-lode-bucket /var/www/html
echo "*/2 * * * * root aws s3 sync s3://tm-lode-bucket /var/www/html" >> /etc/crontab

echo "for filename in \$(ls -1 /var/www/html); do mysql -u remote -premote -h 10.0.1.100 -e \"USE files; INSERT INTO file (name) VALUES ('\$filename');\"; done" > /home/ubuntu/sql.sh
sudo chmod 777 /home/ubuntu/sql.sh
echo "*/2 * * * * root sudo /home/ubuntu/sql.sh" >> /etc/crontab
