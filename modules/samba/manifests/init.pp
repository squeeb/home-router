class samba {
  package { "samba":
    ensure => "latest",
  }

  service { "smbd":
    ensure => "running",
    enable => true,
    require => Package["samba"],
  }

  class { "samba::config": }

}
