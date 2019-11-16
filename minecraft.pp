file { '/home/minecraft':
	ensure => 'directory',
	owner => 'minecraft',
}

user { 'minecraft':
	ensure => present,
	home => '/home/minecraft',
}

package { 'default-jre':
	ensure => installed,
}

file { '/home/minecraft/server.properties':
	source => '/home/kmo/minecraft/server.properties',
	owner => 'minecraft',
}

file { '/home/minecraft/eula.txt':
	content => 'eula=true',	
	owner => 'minecraft',
}

file { '/home/minecraft/server.jar':
	source => 'https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar',
	owner => 'minecraft',
}

$memory_available = $facts['memory']['system']['available_bytes'] / 2

file { '/etc/systemd/system/minecraft.service':
	content => template('/home/kmo/minecraft/minecraft.service.erb'),
	owner => 'minecraft',
}

service { 'minecraft':
	name => 'minecraft',
	ensure => running,
}

file { '/home/minecraft/backups':
	ensure => 'directory',
	owner => 'minecraft',
}

file { '/home/minecraft/backup.sh':
	source => '/home/kmo/minecraft/backup.sh',
	owner => 'minecraft',
	mode => '600',
}

cron { 'mcbackup':
	command => 'source /home/minecraft/backup.sh',
	user => 'minecraft',
	minute => '*',
}

exec { 'swapstuff':
	command => 'dd if=/dev/zero of=/swapfile count=4G',
	creates => '/swapfile',
	user => 'root',
	path => ["/bin", "/usr/bin", "/sbin", "/usr/sbin"]
}

exec { 'swapwhoop':
	command => 'mkswap /swapfile && swapon /swapfile',
	unless => 'swapon -s | grep swapfile',
	user => 'root',
	path => ["/bin", "/usr/bin", "/sbin", "/usr/sbin"]
}
