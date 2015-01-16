# -*- mode: ruby -*-

group { 'puppet':
	ensure => 'present',
}

package { 'libnss-mdns':
	ensure  => present,
}

file { '/etc/apt/sources.list.d/10gen.list':
	ensure  => 'present',
	source  => '/vagrant/manifests/10gen.list',
}

exec { 'add-10genkey':
  command => '/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && /usr/bin/apt-get update && touch /home/vagrant/updated',
  path    => '/usr/local/bin/:/bin/:/usr/bin/',
  creates => '/home/vagrant/updated',
	require => File['/etc/apt/sources.list.d/10gen.list'],
}

package { 'mongodb-org':
	ensure  => present,
	require => Exec['add-10genkey'],
}

file { '/etc/mongod.conf':
	ensure  => present,
	source  => '/vagrant/manifests/mongod.conf',
	require => Package['mongodb-org'],
}

service{ 'mongod':
  ensure => running,
  subscribe => File['/etc/mongod.conf'],
}
