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
