class couchpotato {

  $couchpotato_root = "/usr/share/couchpotato"
  $couchpotato_port = hiera("couchpotato::config::http_port")
  $download_dir = "/data/Movies"

  user::system { "couchpotato":
    comment => "CouchPotato",
    uid => 1009,
    gid => 2009,
    groups => [
      "couchpotato",
      "download"
    ],
  }

  package { "python-cheetah":
    ensure => "latest",
  }

  file { $couchpotato_root:
    ensure => "directory",
    owner => "couchpotato",
    group => "staff",
    mode => "6775",
    require => User::System["couchpotato"],
  }

  exec { "install-couchpotato":
    command => "su couchpotato -c 'git clone https://github.com/RuudBurger/CouchPotatoServer.git ${couchpotato_root}'",
    creates => "${couchpotato_root}/CouchPotato.py",
    require => [
      Class["git"],
      File[$couchpotato_root]
    ],
  }

  exec{ "install-couchpotato-init":
    command => "ln -sf ${couchpotato_root}/init/ubuntu /etc/init.d/couchpotato",
    creates => "/etc/init.d/couchpotato",
    require => Exec["install-couchpotato"],
  }

  file { "/etc/default/couchpotato":
    ensure => "file",
    owner => "root",
    group => "root",
    mode => "0660",
    notify => Service["couchpotato"],
    content => template("couchpotato/defaults.erb"),
  }

  file { [
    "/etc/couchpotato",
    "/var/run/couchpotato"
  ]:
    ensure => "directory",
    owner => "couchpotato",
    group => "download",
    mode => "6775",
    require => [
      Exec["install-couchpotato"],
      User::System["couchpotato"],
    ],
  }

  service { "couchpotato":
    ensure => "running",
    enable => true,
    require => [
      File["/etc/couchpotato"],
      File["/etc/default/couchpotato"],
      Exec["install-couchpotato-init"]
    ],
  }

  file { $download_dir:
    ensure => "directory",
    owner => "couchpotato",
    group => "download",
    mode => "6775",
    require => User::System["couchpotato","download"],
  }

}
