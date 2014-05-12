class apache2 {
  package { "apache2":
    ensure => "latest",
  }

  service { "apache2":
    ensure => "running",
    enable => true,
    require => [
      Exec["a2enmod rewrite"],
      Package["apache2"]
    ],
  }

  exec { "a2enmod rewrite":
    creates => "/etc/apache2/mods-enabled/rewrite.load",
  }
}
