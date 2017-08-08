# CentOS Node Development
---

Takes a lot of inspiration from [Homestead]. Allows easy provision of a Centos development environment allowing easy to configure nginx reverse proxy to multiple `node` apps.

Simply edit `config.json` to requirments and add `uri` to hostsfile.

## Requirments
- [Vagrant]
- [VirtualBox]

## Usage
```sh
$ git clone https://github.com/amwill04/centos.git
$ cd centos
$ vagrant up
```

## Included
- Centos 7
- Node v8.x
- Nginx
- MariaDB
- Redis

## .bash_profile
Included in repo is .bash_profile that will sync with ~/.bash_profile.

## pm2
If is included `true` in `config.json` then and `process.json` file needs to be places in root. For further info on see [pm2].

```json
{
  "apps" : [{
    "name"        : "app",
    "script"      : "/full/path/to/app.js",
    "watch"       : true,
    "env": {
      "NODE_ENV": "development"
    }
  }]
}
```

## Config
To configure vm adjust config file to suit.
```json
{
  "ip": "192.168.33.10",
  "memory": 2048,
  "cpus": 1,
  "folders": [{
    "map": "~/git/Test",
    "to": "/home/vagrant/Test",
    "type": "nfs"
  }],
  "sites": [{
    "map": "test.app",
    "to": 8000,
  }],
  "pm2": false,
  "databases": [
    "test"
  ]
}
```

### Config API
#### ip
Private IP addres of vm

#### memory
Provisioned RAM available

#### cpus
Number of provisioned cpus

#### folders
##### folders[map]
Location of directory root of folder on host to be shared with guest
##### folders[to]
Location on guest box to sync to
##### folders[type]
Enable nfs (MacOS only)

#### sites
##### sites[map]
url for nginx reverse proxy. Must be added to hostsfile `/private/etc/hosts` on MacOS mapped to ip address configured.
##### sites[to]
port number node app is configured to listen on. If running multiple sites from vm then each node app must be listening on different port numbers.

##### sites[root]
The entry point to you app. Full path must be provided.

#### databases
Array of databases to be provisioned. Useful if using migrations and seeders



[Vagrant]: <https://www.vagrantup.com/>
[VirtualBox]: <https://www.virtualbox.org/>
[Homestead]: <https://github.com/laravel/homestead>
[pm2]: <http://pm2.keymetrics.io/>
