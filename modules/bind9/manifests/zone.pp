define bind9::zone(
  $type,
  $ttl,
  $soa,
  $records
){
  file { "/etc/bind/zones/${name}.zone":
    ensure  => file,
    owner   => 'root',
    group   => 'bind',
    mode    => '0640',
    content => template('bind9/zone.erb'),
    notify  => Service['bind9'],
  }

  file { "/etc/bind/zones/${name}.conf":
    ensure =>  file,
    owner   => 'root',
    group   => 'bind',
    mode    => '0640',
    content => template('bind9/zone.conf.erb'),
  }

  file_line { "include_${name}":
    path   => '/etc/bind/named.conf',
    line   => "include \"/etc/bind/zones/${name}.conf\";",
    match  => "^include \"/etc/bind/zones/${name}",
    notify => Service['bind9'],
  }

}
