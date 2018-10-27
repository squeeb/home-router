class transmission {
  package { "transmission-daemon":
    ensure => "latest",
  }

  service { "transmission-daemon":
    ensure => "running",
    enable => true,
  }
}
