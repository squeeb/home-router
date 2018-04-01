class netatalk($shares = []) {
  package { 'netatalk':
    ensure => 'latest',
  }

  file { '/etc/netatalk/netatalk.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    source  => 'puppet:///modules/netatalk/sysconfig.conf',
    require => Package['netatalk'],
    notify  => Service['netatalk'],
  }

  file { '/etc/netatalk/AppleVolumes.default':
    ensure => 'file',
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('netatalk/AppleVolumes.default.erb'),
    require => File['/etc/netatalk/netatalk.conf'],
    notify => Service['netatalk'],
  }

  service { 'netatalk':
    ensure   => 'running',
    enable   => true,
    require  => File['/etc/netatalk/AppleVolumes.default'],
  }

}
