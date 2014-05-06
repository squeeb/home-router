class sickbeard {

  $sickbeard_root = "/usr/share/sickbeard"
  $download_dir = "/data/TV"

  user::system { "sickbeard":
    comment => "Sick Beard",
    uid => 1008,
    gid => 2008,
    groups => [
      "sickbeard",
      "download"
    ],
  }

  package { "python-cheetah":
    ensure => "latest",
  }

  file { $sickbeard_root:
    ensure => "directory",
    owner => "sickbeard",
    group => "staff",
    mode => "6770",
    require => User::System["sickbeard"],
  }

  exec { "install-sickbeard":
    command => "su sickbeard -c 'git clone git://github.com/midgetspy/Sick-Beard.git ${sickbeard_root}'",
    creates => "${sickbeard_root}/SickBeard.py",
    require => [
      Class["git"],
      File[$sickbeard_root]
    ],
  }

  exec{ "install-sickbeard-init":
    command => "ln -s ${sickbeard_root}/init.ubuntu /etc/init.d/sickbeard",
    creates => "/etc/init.d/sickbeard",
    require => Exec["install-sickbeard"],
  }

  file { "/etc/default/sickbeard":
    ensure => "file",
    owner => "root",
    group => "root",
    mode => "0660",
    notify => Service["sickbeard"],
    content => template("sickbeard/defaults.erb"),
  }

  file { "/etc/sickbeard":
    ensure => "directory",
    owner => "sickbeard",
    group => "staff",
    mode => "6775",
  }

  service { "sickbeard":
    ensure => "running",
    enable => true,
    require => [
      File["/etc/sickbeard"],
      File["/etc/default/sickbeard"],
      Exec["install-sickbeard-init"]
    ],
  }

  file { $download_dir:
    ensure => "directory",
    owner => "sickbeard",
    group => "download",
    mode => "6775",
    require => User::System["sickbeard","download"],
  }
}
