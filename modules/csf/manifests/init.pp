class csf {
  class { "csf::config": }
  class { "perl::libwww": }
  class { "perl::time_hires": }

  exec { "get-csf":
    cwd   => "/tmp",
    command => "wget http://configserver.com/free/csf.tgz -O /tmp/csf.tgz",
    creates => "/tmp/csf.tgz",
  }

  exec { "build-csf":
    cwd     => "/tmp",
    command   => "/bin/tar zxvf /tmp/csf.tgz && cd csf && /bin/sh install.sh",
    require   => [
      Class["perl::libwww"],
      Exec["get-csf"]
    ],
    creates   => "/etc/csf/csf.pl",
    logoutput => "on_failure",
    timeout   => 0,
  }

  service { "csf":
    ensure => "running",
    enable => true,
    hasrestart => false,
    restart => "csf -r",
    require => Service["lfd"],
  }

  service { "lfd":
    ensure => "running",
    enable => true,
    hasrestart => true,
    require => Exec["build-csf"],
  }
}
