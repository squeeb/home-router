class php::mysql {
  package { "php-mysql":
    ensure => "latest",
    require => Class["mysql::server"],
  }
}
