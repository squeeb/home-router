class sabnzb {
  $run_as_user = hiera("sabnzb::config::run_as_user")
  $https_port = hiera("sabnzb::config::https_port")

  package {[
    "sabnzbdplus",
    "sabnzbdplus-theme-iphone",
    "sabnzbdplus-theme-plush"
  ]:
    ensure => "latest",
    require => Class["unrar"],
  }

  user::system { "sabnzb":
    comment => "Debian Transmission Daemon",
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
    group => "staff",
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
