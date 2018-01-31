class postfix(
  $local_domain,
  $local_hostname = undef,
  $relay = false,
  $use_upstream_mta = false,
  $use_upstream_mx_records = false,
  $mx_domain = undef,
  $upstream_mta_server = undef,
  $virtual_domains = [],
  $restricted_sender_domains = [],
  $service_ensure = 'running',
){

  $sysadmin_email_address = hiera('sysadmin::email_address')

  if ($use_upstream_mta) and ($use_upstream_mx_records == false) and ($upstream_mta_server == undef) {
    fail('You must assign an upstream_mta_server if you are not using MX lookups for the upstream MTA.')
  }

  if ($use_upstream_mta) and ($use_upstream_mx_records) and ($mx_domain == undef) {
    fail('You must assign an mx_domain if you are using MX lookups for the upstream MTA')
  }

  if $relay {
    file { '/etc/postfix/sender_access':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0664',
      content => template('postfix/sender_access.erb'),
      require => Package['postfix'],
      notify  => Exec['create_sender_restrictions'],
    }

    exec { 'create_sender_restrictions':
      command     => 'postmap /etc/postfix/sender_access',
      require     => File['/etc/postfix/sender_access'],
      notify      => Service['postfix'],
      refreshonly => true,
    }
  }

  $listen = $relay ? {
    true => 'all',
    default => 'loopback-only',
  }

  $daemon_directory = $::operatingsystem ? {
    /^(Debian|Ubuntu)$/ => '/usr/lib/postfix',
    default => '/usr/libexec/postfix',
  }

  package { 'postfix':
    ensure => 'installed',
  }

  package { ['sendmail', 'sendmail-cf']:
    ensure => 'absent',
    require => Package['postfix'],
  }

  service { 'postfix':
    ensure => $service_ensure,
    enable => true,
    start  => '/usr/sbin/postfix stop ; /usr/sbin/postfix start',
  }

  file { '/etc/postfix/generic':
    ensure => 'file',
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('postfix/generic.erb'),
    require => Package['postfix'],
    notify => Exec['create_genericdb'],
  }

  file { '/etc/postfix/main.cf':
    ensure => 'file',
    owner => 'root',
    group => 'root',
    mode => '0644',
    require => Package['postfix'],
    content => template('postfix/main.cf.erb'),
    notify => Service['postfix'],
  }

  file { '/etc/postfix/virtual':
    ensure => 'file',
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('postfix/virtual.erb'),
    require => Package['postfix'],
    notify => Exec['create_virtualdb'],
  }

  file { '/etc/aliases':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file_line {'forward_line':
    ensure  => 'present',
    path    => '/etc/aliases',
    line    => "root: ${sysadmin_email_address}",
    require => File['/etc/aliases'],
    notify  => Exec['newaliases'],
  }

  file_line { 'devnull_line':
    ensure => 'present',
    path => '/etc/aliases',
    line => 'devnull: /dev/null',
    require => File['/etc/aliases'],
    notify => Exec['newaliases'],
  }

  exec { 'create_virtualdb':
    command     => 'postmap /etc/postfix/virtual',
    require     => File['/etc/postfix/virtual'],
    notify      => Service['postfix'],
    refreshonly => true,
  }

  exec { 'create_genericdb':
    command     => 'postmap /etc/postfix/generic',
    require     => File['/etc/postfix/generic'],
    notify      => Service['postfix'],
    refreshonly => true,
  }

  exec { 'newaliases':
    command     => '/usr/bin/newaliases',
    refreshonly => true,
    notify      => Service['postfix'],
    require     => Package['postfix'],
  }
}
