class samba {

  $workgroup = hiera("samba::workgroup")
  $shares = hiera_hash("samba::shares")

  package { "samba":
    ensure => "latest",
  }

  service { "smbd":
    ensure => "running",
    enable => true,
    require => Package["samba"],
  }

  class { "samba::config":
    workgroup => $workgroup,
    shares => $shares,
  }

}
