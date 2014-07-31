class puppet {
  package { "puppet":
    ensure => "3.4.3-1puppetlabs1",
    require => Class["repo"],
  }

  file { "/etc/puppet/puppet.conf":
    ensure => "file",
    owner => "puppet",
    group => "staff",
    mode => "0660",
    source => "puppet:///modules/puppet/puppet.conf",
    require => Package["puppet"],
  }

  service { "puppet":
    ensure => "stopped",
    enable => false,
    require => File["/etc/puppet/puppet.conf"],
  }

  cron { "puppet-up":
    command => "/usr/local/bin/puppet-up > /dev/null 2>&1",
    hour    => "*",
    minute  => "0",
    require => [
      Class["environment"],
    ],
  }
  cron { "puppet-run":
    command => "/usr/local/bin/puppet-run > /dev/null 2>&1",
    hour    => "*",
    minute  => "2",
    require => [
      Class["environment"],
      File["/etc/puppet/puppet.conf"],
    ],
  }
}
