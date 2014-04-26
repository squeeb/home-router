define user::system(
  $uid,
  $gid,
  $gid_name,
  $server_roles,
  $comment,
  $enabled,
  $homedir = undef,
) {

  if $enabled and $role in $server_roles {
    $ensure = "present"
  } else {
    $ensure = "absent"
  }

  user { $name:
    uid => $uid,
    gid => $gid_name,
    comment => $comment,
    shell => "/bin/bash",
    managehome => $homedir ? {
      undef => false,
      default => true,
    },
    home => $homedir ? {
      undef => undef,
      default => $homedir,
    },
    ensure => $ensure,
  }

  group { $gid_name:
    name => $gid_name,
    gid => $gid,
    ensure => $ensure,
  }

  # We can't remove the group until the user has been purged, but we can't
  # create the user until the group already exists, this sorts out the stupid
  # dependency issue
  if $ensure == "present" {
    Group[$gid_name] -> User[$name]
  } else {
    User[$name] -> Group[$gid_name]
  }
}
