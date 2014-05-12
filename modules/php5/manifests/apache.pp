class php5::apache {
  file { "/etc/php5/apache2/php.ini":
    ensure => "file",
    owner => "root",
    group => "www-data",
    mode => "0644",
    source => "puppet:///modules/php5/apache/php.ini",
    require => Package[
      "apache2",
      "libapache2-mod-php5"
    ],
    notify => Service["apache2"],
  }
}
