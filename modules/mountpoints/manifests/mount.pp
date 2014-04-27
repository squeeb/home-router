define mountpoints::mount(
  $fstype = "auto",
  $device,
  $options = "defaults",
  $fsck_enabled = "0",
  $dump_enabled = "0",
  $enabled = true,
  $require_mountpoint = undef,
) {

  case $fstype {
    "nfs",
    "nfs4" : {
      class { "nfs": }
    }
  }

  $ensure = $enabled ? {
    true => "mounted",
    false => "absent",
  }

  file { $name:
    ensure => "directory",
  }

  $mount_requirements = $require_mountpoint ? {
    undef => File[$name],
    default => [File[$name], Mount[$require_mountpoint]],
  }

  mount { $name:
    name    => $name,
    device  => $device,
    dump    => $dump_enabled,
    fstype  => $fstype,
    options => $options,
    pass    => $fsck_enabled,
    ensure  => $ensure,
    require => $mount_requirements,
  }

}
