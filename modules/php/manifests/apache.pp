class php::apache {
  file { "/etc/php/apache2/php.ini":
    ensure => "file",
    owner => "root",
    group => "www-data",
    mode => "0644",
    source => "puppet:///modules/php/apache/php.ini",
    require => Package[
      "apache2",
      "libapache2-mod-php"
    ],
    notify => Service["apache2"],
  }
}
