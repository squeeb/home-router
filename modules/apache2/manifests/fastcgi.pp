class apache2::fastcgi {
  package { "libapache2-mod-fastcgi":
    ensure => "installed",
    require => Package["apache2"],
  }

  exec { "a2enmod fastcgi":
    creates => "/etc/apache2/mods-enabled/fastcgi.load",
    require => Package["libapache2-mod-fastcgi"],
    notify => Service["apache2"],
  }
}
