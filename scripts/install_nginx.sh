# Nginx
sudo yum install epel-release -y 1>/dev/null
sudo yum install nginx -y 1>/dev/null
sudo rm /etc/nginx/nginx.conf
sudo mv /home/vagrant/nginx.conf /etc/nginx/
if [ ! -d "/etc/nginx/sites-available" ]; then
  sudo mkdir /etc/nginx/sites-available
  sudo mkdir /etc/nginx/sites-enabled
fi

sudo setenforce Permissive

# Start nginx and add to start up
sudo systemctl start nginx
sudo systemctl enable nginx
