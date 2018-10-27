class sysctl {
  $sysctl_options = hiera_hash("sysctl::options", {})

  file { "/etc/sysctl.conf":
    ensure  => "present",
    owner   => "root",
    group   => "root",
    mode    => "0644",
    content => template("sysctl/sysctl.conf.erb"),
    notify  => Exec["sysctl-set"],
  }

  exec { "sysctl-set":
    path        => '/sbin',
    command     => "sysctl -p",
    refreshonly => true,
  }
}

