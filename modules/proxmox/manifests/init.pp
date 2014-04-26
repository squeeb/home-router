class proxmox {

  file { "/etc/vz":
    ensure => "directory",
    source => "puppet:///modules/proxmox/etc/",
    recurse => true,
    owner => "root",
    group => "root",
  }

}
