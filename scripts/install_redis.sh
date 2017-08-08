if ! type redis-cli >/dev/null 2>&1 ; then
  sudo yum install -y redis 1>/dev/null
  # Start Redis
  sudo systemctl start redis
  sudo systemctl enable redis
fi
