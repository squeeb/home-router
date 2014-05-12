class mysql::server {
  package { "mysql-server":
    ensure => "latest",
  }

  service { "mysql":
    ensure => "running",
    enable => true,
    require => Package["mysql-server"],
  }

}
