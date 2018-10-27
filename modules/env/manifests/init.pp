class env {
  $environment_content = $operatingsystem ? {
    /^(Debian|Ubuntu)$/ => template("env/environment.ubuntu_defaults.erb", "env/environment.erb"),
    default             => template("env/environment.erb"),
  }

  file { "/etc/environment":
    ensure => "present",
    content => $environment_content,
    mode => "0644",
    owner => "root",
    group => "root",
  }

  file { "/usr/local/bin/puppet-up":
    ensure  => "file",
    source  => "puppet:///modules/env/puppet-up.sh",
    owner   => "root",
    group   => "root",
    mode    => "0755",
    require => Class["git"],
  }

  file { "/usr/local/bin/puppet-run":
    ensure  => "file",
    content => template("env/puppet-run.sh.erb"),
    owner   => "root",
    group   => "root",
    mode    => "0755",
    require => Class["git"],
  }
}
