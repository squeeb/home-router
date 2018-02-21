class sudo {

  $defaults = hiera('sudo::defaults', [])
  $command_aliases = hiera('sudo::command_aliases', [])
  $groups = hiera('sudo::groups', [])
  $users = hiera('sudo::users', [])

  $sudoers = '/etc/sudoers'

  package { 'sudo':
    ensure => 'installed',
  }

  file { $sudoers:
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode => '0440',
    content => template('sudo/sudoers.erb'),
    require => Package['sudo'],
  }
}
