class php5::mysql {
  package { "php5-mysql":
    ensure => "latest",
    require => Class["mysql::server"],
  }
}
