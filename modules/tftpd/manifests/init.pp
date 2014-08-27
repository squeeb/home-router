class tftpd(
  $tftproot_path = "/tftproot"
) {
  package { "xinetd":
    ensure => "latest",
  }

  package { "atftpd":
    ensure => "latest",
    require => Package["xinetd"],
  }

  file { $tftproot_path:
    ensure => "directory",
    mode => "0777",
    owner => "nobody",
    group => "nogroup",
  }

  file { "/etc/xinetd.d/tftpd":
    ensure => "file",
    owner => "root",
    group => "root",
    mode => "0660",
    content => template("tftpd/xinetd.conf.erb"),
    require => Package["xinetd"],
    notify => Service["xinetd"],
  }

  service { "xinetd":
    ensure => "running",
    enable => true,
    require => Package["xinetd"],
  }

  csf::acl { "tftpd":
    protocol => "udp",
    ports => ["69"],
  }
}
