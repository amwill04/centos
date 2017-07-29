# install mariadb
sudo yum -y install mariadb-server 2>/dev/null

# Start and start on boot
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service

### post-install setup

# set root password
sudo /usr/bin/mysqladmin -u root password 'password'

# allow remote access (required to access from our private network host. Note that this is completely insecure if used in any other way)
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# drop the anonymous users
mysql -u root -ppassword -e "DROP USER ''@'localhost';"
mysql -u root -ppassword -e "DROP USER ''@'$(hostname)';"

# drop the demo database
mysql -u root -ppassword -e "DROP DATABASE test;"

# Create default vagrant user
mysql -u root -ppassword -e "CREATE USER 'vagrant'@'0.0.0.0' IDENTIFIED BY 'vagrant';"
mysql -u root -ppassword -e "GRANT ALL ON *.* TO 'vagrant'@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql -u root -ppassword -e "GRANT ALL ON *.* TO 'vagrant'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql -u root -ppassword -e "FLUSH PRIVILEGES;"

# restart
sudo systemctl restart mariadb.service
