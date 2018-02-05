class postfix(
  $local_domain,
  $local_hostname = undef,
  $relay = false,
  $use_upstream_mta = false,
  $use_upstream_mx_records = false,
  $mx_domain = undef,
  $upstream_mta_server = undef,
  $restricted_sender_domains = [],
  $service_ensure = 'running',
  $virtual_domains,
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

  exec { 'newaliases':
    command     => '/usr/bin/newaliases',
    refreshonly => true,
    notify      => Service['postfix'],
    require     => Package['postfix'],
  }
}
