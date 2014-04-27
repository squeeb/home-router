define user::standard(
  $uid,
  $gid = $name,
  $comment,
  $groups = [],
  $ssh_public_key,
  $ssh_key_type,
  $custom_bashrc = false,
  $ensure = "present"
) {


  user { "${name}":
    uid => $uid,
    groups => $groups,
    comment => $comment,
    managehome => true,
    shell => "/bin/bash",
    ensure => $ensure,
  }

  if $ensure == "present" {
    ssh_authorized_key { "${name}":
      key => $ssh_public_key,
      type => $ssh_key_type,
      user => $name,
      ensure => "present",
      require => User[$name],
    }

    if $custom_bashrc == true {
      file { "/home/${name}/.bashrc":
        ensure => "file",
        source => "puppet:///modules/user/files/bash_profiles/${name}.sh",
        require => User[$name],
        owner => $name,
        group => $gid,
        mode => "0600",
      }
    } else {
      file { "/home/${name}/.bashrc":
        ensure => "absent",
        require => User[$name],
      }
    }
  }
}
