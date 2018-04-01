class bind9(
  $forwarders = ['8.8.8.8'],
  $acls = [],
  $recursion = false,
  $zones = {},
){
  package { 'bind9':
    ensure => 'latest',
  }

  file { '/etc/bind/named.conf.options':
    ensure  => 'file',
    content => template('bind9/named.conf.options.erb'),
    require => Package['bind9'],
    notify  => Service['bind9'],
  }

  service { 'bind9':
    ensure  => 'running',
    enable  => true,
    require => File['/etc/bind/named.conf.options'],
  }

  file { '/etc/bind/zones/':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'bind',
    mode    => '0750',
    require => Package['bind9'],
  }

  create_resources('bind9::zone', $zones, $defaults = { require => File['/etc/bind/zones/']})
}
