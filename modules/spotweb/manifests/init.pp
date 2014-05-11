class spotweb {
  package { "spotweb":
    ensure => "latest",
  }

  file { "/etc/apache2/conf.d/spotweb.conf":
    ensure => "absent",
  }

  file { "/etc/apache2/sites-available/spotweb.conf":
    ensure => "file",
    owner => "root",
    group => "root",
    mode => "0644",
    source => "puppet:///modules/spotweb/apache/spotweb.conf",
    require => Package[
      "apache2",
      "spotweb"
    ],
    notify => Service["apache2"],
  }

  file { "/etc/apache2/sites-enabled/spotweb.conf":
    ensure => "link",
    target => "/etc/apache2/sites-available/spotweb.conf",
    require => File["/etc/apache2/sites-available/spotweb.conf"],
    notify => Service["apache2"],
  }
}
