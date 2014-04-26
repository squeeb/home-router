class proxmox::scripts {
  file { "/opt/proxmox":
    ensure => "directory",
    mode => "0755",
    owner => "root",
    group => "root",
  }

  file { "/opt/proxmox/bin":
    ensure => "directory",
    source => "puppet:///modules/proxmox/bin/",
    recurse => true,
    mode => "0755",
    owner => "root",
    group => "root",
    require => File["/opt/proxmox"],
  }

  file { "/etc/profile.d/proxmox.sh":
    ensure => "present",
    content => 'export PATH=/opt/proxmox/bin:$PATH',
    owner => "root",
    group => "root",
    mode => "0755",
  }
}
