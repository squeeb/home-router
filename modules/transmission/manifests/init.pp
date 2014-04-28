class transmission {
  $config = hiera("transmission")

  package { "transmission-daemon":
    ensure => "latest",
  }

  file { "/etc/transmission-daemon/settings.json":
    ensure => "file",
    owner => "debian-transmission",
    group => "debian-transmission",
    mode => "0600",
    content => template("transmission/settings.json.erb"),
    require => Package["transmission-daemon"],
  }

  file {[
    $config["download_dir"],
    "${config['download_dir']}/incomplete"
  ]:
    ensure => "directory",
    owner => "debian-transmission",
    group => "staff",
    mode => "0770",
  }

  service { "transmission-daemon":
    ensure => "running",
    enable => true,
    subscribe => File["/etc/transmission-daemon/settings.json"],
  }
}
