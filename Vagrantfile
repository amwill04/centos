# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

confDir = File.expand_path(File.dirname(__FILE__))
configJSON = confDir + "/config.json"
scriptDir = confDir + "/scripts"

Vagrant.configure("2") do |config|

  if File.exist? configJSON then
      settings = JSON.parse(File.read(configJSON))
  else
      abort "config.json not found in #{confDir}"
  end

  config.vm.box = settings["box"] ||= "centos/7"
  config.vm.define settings["name"] ||= "centos-7"
  config.vm.network "private_network", ip: settings["ip"] ||= "192.168.33.10"

  # Configure A Few VirtualBox Settings
  config.vm.provider "virtualbox" do |vb|
      vb.name = settings["name"] ||= "centos-7"
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", settings["natdnshostresolver"] ||= "on"]
      vb.customize ["modifyvm", :id, "--ostype", "Fedora_64"]
      if settings.has_key?("gui") && settings["gui"]
          vb.gui = true
      end
  end

  # Register All Of The Configured Shared Folders
  if settings.include? 'folders'
      settings["folders"].each do |folder|
          if File.exists? File.expand_path(folder["map"])
              mount_opts = []

              if (folder["type"] == "nfs")
                  mount_opts = folder["mount_options"] ? folder["mount_options"] : ['actimeo=1', 'nolock']
              elsif (folder["type"] == "smb")
                  mount_opts = folder["mount_options"] ? folder["mount_options"] : ['vers=3.02', 'mfsymlinks']
              end

              # For b/w compatibility keep separate 'mount_opts', but merge with options
              options = (folder["options"] || {}).merge({ mount_options: mount_opts })

              # Double-splat (**) operator only works with symbol keys, so convert
              options.keys.each{|k| options[k.to_sym] = options.delete(k) }

              config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil, **options

              # Bindfs support to fix shared folder (NFS) permission issue on Mac
              if Vagrant.has_plugin?("vagrant-bindfs")
                  config.bindfs.bind_folder folder["to"], folder["to"]
              end
          else
              config.vm.provision "shell" do |s|
                  s.inline = ">&2 echo \"Unable to mount one of your folders. Please check your folders in config.json\""
              end
          end
      end
  end

  # Install nano and wget
  config.vm.provision "shell" do |s|
      s.name = "Installing default programs."
      s.inline = "sudo yum install wget nano gcc-c++ make -y 1>/dev/null"
  end

  # Move nginx.conf file
  config.vm.provision "file", source: scriptDir + "/nginx.conf", destination: "~/nginx.conf"

  # Install Nginx Sites
  config.vm.provision "shell" do |s|
      s.path = scriptDir + "/install_nginx.sh"
  end

  if settings.include? 'sites'
      settings["sites"].each do |site|
          # Create SSL certificate
          config.vm.provision "shell" do |s|
              s.name = "Creating Certificate: " + site["map"]
              s.path = scriptDir + "/create_certificate.sh"
              s.args = [site["map"]]
          end
          config.vm.provision "shell" do |s|
              s.name = "Creating Site: " + site["map"]
              s.path = scriptDir + "/create_proxy.sh"
              s.args = [site["map"], site["to"], site["port"] ||= "80", site["ssl"] ||= "443", params ||= ""]
          end
      end
  end

  config.vm.provision "shell" do |s|
      s.name = "Restarting Nginx"
      s.inline = "sudo service nginx restart"
  end

  config.vm.provision "shell" do |s|
    s.name = "Installing Node."
    s.path = scriptDir + "/install_node.sh"
  end

  if settings.include? 'node_global'
    settings["node_global"].each do |pkg|
      config.vm.provision "shell" do |s|
        s.name = "Installing: " + pkg
        s.inline = "npm install -g " + pkg + "1>/dev/null"
      end
    end
  end

  # Start node apps
  if settings.include? 'sites'
    settings["sites"].each do |site|
      config.vm.provision "shell" do |s|
        s.name = "Start pm2 for " + site["map"]
        s.privileged = false
        s.inline = "pm2 start " + site["root"]
      end
    end
  end

  # Start pm2 on start up
  config.vm.provision "shell" do |s|
    s.name = "Start pm2 on startup."
    s.inline = "sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant 1>/dev/null"
  end

  # Turn off SELinux at boot always
  config.vm.provision "shell", run: "always" do |s|
    s.name = "Turn off SELinux"
    s.inline = "sudo setenforce Permissive && sudo systemctl restart nginx"
  end

  # Install MariaDB and create databases
  config.vm.provision "shell" do |s|
    s.name = "Install MariaDB"
    s.path = scriptDir + "/install_mariadb.sh"
  end

  if settings.include? 'databases'
    settings["databases"].each do |db|
      config.vm.provision "shell" do |s|
        s.name = "Creating " + db + " schema"
        s.path = scriptDir + "/create_schema.sh"
        s.args = db
      end
    end
  end

end
