class environment {
  $environment_content = $operatingsystem ? {
    /^(Debian|Ubuntu)$/ => template("environment/environment.ubuntu_defaults.erb", "environment/environment.erb"),
    default             => template("environment/environment.erb"),
  }

  file { "/etc/environment":
    ensure => "present",
    content => $environment_content,
    mode => "0644",
    owner => "root",
    group => "root",
  }

  file { "/usr/local/bin/puppet-up":
    ensure  => $role ? {
      "puppetmaster" => "present",
      default        => "absent",
    },
    source  => "puppet:///modules/environment/puppet-up.sh",
    owner   => "root",
    group   => "root",
    mode    => "0755",
    require => Class["git"],
  }

  file { "/usr/local/bin/puppet-run":
    ensure => "absent",
  }
}
