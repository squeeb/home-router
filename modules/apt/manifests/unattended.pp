class apt::unattended {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  package {[
    'unattended-upgrades',
    'apt-listchanges'
  ]:
    ensure => latest,
  }

  file { '/etc/apt/apt.conf.d/20auto-upgrades':
    ensure => file,
    source => 'puppet:///modules/apt/20auto-upgrades',
  }

  file { '/etc/apt/listchanges.conf':
    ensure => file,
    source => 'puppet:///modules/apt/listchanges.conf',
  }
}
