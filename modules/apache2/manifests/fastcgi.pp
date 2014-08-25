class apache2::fastcgi {
  package { "libapache2-mod-fcgid":
    ensure => "installed",
    require => Package["apache2"],
  }

  exec { "a2enmod fcgid":
    creates => "/etc/apache2/mods-enabled/fcgid.load",
    require => Package["libapache2-mod-fcgid"],
    notify => Service["apache2"],
  }
}
