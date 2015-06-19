# Vagrant MongoDB Sharding Definitions

## Purpose

This is forked from [MUGBerlin/vagrant-machines](https://github.com/MUGBerlin/vagrant-machines).
[Vagrant](http://vagrantup.com/) is a nice way to experiment with technologies without polluting your own machine with software.

## Preconditions

Please follow the install instructions at http://vagrantup.com/.

## What it Does

This sets up 4 servers with MongoDB connected via a host-only network.


#### Clone this repo

```
$> git clone https://github.com/mrico/vagrant-mongo-shards.git
```

#### Startup:

```
vagrant up
```

The startup can take a while.

The IP addresses of the 3 shard servers are

- shard01.local
- shard02.local
- shard03.local

The IP adress of the configserver

- configsrv.local

Each server has the same setup. If you want to connect to a certain server via ssh use (e.g. shard01):

```
vagrant ssh shard01
```

#### Run a mongos instance on your host

```
mongos --configdb configsrv.local
```


#### Connect to the MongoDB instances from your host:

```
mongo
```

#### Add the shards 

```
sh.addShard( "shard01.local:27017" )
sh.addShard( "shard02.local:27017" )
sh.addShard( "shard03.local:27017" )
```

### Ready

Congrats! Your mongo cluster is up and running! 

Don't forget to enable sharding for you database. e.g.

```
mongos>sh.enableSharding("myDb");
```



#### Set chunk size to something demo usable (optional)

```
use config
db.settings.save( { _id:"chunksize", value: 1 } )
```

#### Problems

- IP already used within your network
  - open the vagrant file and change the ip of all nodes: xxx.vm.network :hostonly, "10.0.0.24" 

- VT-X is not available / machines are not staring
  - VT-X is required for 64-bit machines. You can switch to a 32-bit base image. Open Vagrantfile and replace all occurence of __precise64__ with __precise32__

#### Links

Useful link to the MongoDB documentation: http://docs.mongodb.org/manual/administration/sharding/
