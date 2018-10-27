class transmission {
  $config = hiera("transmission")

  package { "transmission-daemon":
    ensure => "latest",
    require => User::System["debian-transmission"],
  }

  file { "/home/debian-transmission/.config/transmission-daemon/settings.json":
    ensure => "file",
    owner => "root",
    group => "debian-transmission",
    mode => "0640",
    content => template("transmission/settings.json.erb"),
  }

  file {[
    "/home/debian-transmission",
    "/home/debian-transmission/.config",
    "/home/debian-transmission/.config/transmission-daemon",
  ]:
    ensure => "directory",
    owner => "debian-transmission",
    group => "staff",
    mode => "0770",
    require => Package["transmission-daemon"],
  }

  file {[
    $config["download_dir"],
    "${config['download_dir']}/incomplete"
  ]:
    ensure => "directory",
    owner => "debian-transmission",
    group => "download",
    mode => "6775",
    require => [
      Package["transmission-daemon"],
      User::System["debian-transmission"],
    ],
  }

  file { "/etc/default/transmission-daemon":
    ensure => "file",
    source => "puppet:///modules/transmission/defaults",
    require => [
      Package["transmission-daemon"],
      User::System["debian-transmission"]
    ],
  }

  service { "transmission-daemon":
    ensure => "running",
    enable => true,
    subscribe => File["/home/debian-transmission/.config/transmission-daemon/settings.json"],
  }

  user::system { "debian-transmission":
    comment => "Debian Transmission Daemon",
    uid => 1006,
    gid => 2006,
    groups => [
      "debian-transmission",
      "download"
    ],
  }
}
