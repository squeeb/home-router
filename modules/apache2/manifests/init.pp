class apache2 {
  package { "apache2":
    ensure => "latest",
  }

  service { "apache2":
    ensure => "running",
    enable => true,
    require => Package["apache2"],
  }
}
