class sabnzb {
  $run_as_user = hiera("sabnzb::config::run_as_user")
  $http_port = hiera("sabnzb::config::http_port")
  $sickbeard_port = hiera("sickbeard::config::http_port")

  package { 'sabnzbdplus':
    ensure => "latest",
    require => Class["unrar"],
  }

  user::system { "sabnzb":
    comment => "sabnzb",
    uid => 1007,
    gid => 2007,
    groups => [
      "sabnzb",
      "download"
    ],
  }

  file { "/etc/default/sabnzbdplus":
    ensure => "file",
    owner => "root",
    group => "root",
    mode => "0644",
    require => Package["sabnzbdplus"],
    content => template("sabnzb/defaults.erb"),
    notify => Service["sabnzbdplus"],
  }

  file { "/etc/sabnzb":
    ensure => "directory",
    owner => "sabnzb",
    group => "download",
    mode => "6775",
    require => User::System["sabnzb"],
  }

  service { "sabnzbdplus":
    ensure => "running",
    enable => true,
    require => [
      Package["sabnzbdplus"],
      File["/etc/sabnzb"]
    ],
  }

}
