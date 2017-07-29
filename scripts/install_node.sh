curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash - 1>/dev/null
sudo yum -y install nodejs 1>/dev/null

# Install pm2
sudo npm install -g pm2 1>/dev/null
