define user::system(
  $uid,
  $gid,
  $comment,
  $groups = [$name],
  $ensure = "present"
) {

  user { $name:
    uid => $uid,
    gid => $gid,
    groups => $groups,
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

  group { $name:
    gid => $gid,
    ensure => $ensure,
  }

  # We can't remove the group until the user has been purged, but we can't
  # create the user until the group already exists, this sorts out the stupid
  # dependency issue
  if $ensure == "present" {
    Group[$name] -> User[$name]
  } else {
    User[$name] -> Group[$name]
  }
}
