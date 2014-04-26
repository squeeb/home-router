define apt::repo(
  $enabled = true,
  $location,
  $release,
  $repos,
  $include_src,
  $key = undef,
  $key_source = undef,
  $key_server = undef,
) {

  $ensure = $enabled ? {
    true  => "present",
    false => "absent",
  }

  file {"/etc/apt/sources.list.d/${name}.list":
    ensure  => $ensure,
    owner   => "root",
    group   => "root",
    mode    => "0644",
    content => template("apt/repo.erb"),
    notify  => Exec["apt-get-update-${name}"],
  }

  if ($key) {
    if $enabled == true {
      if ($key_source) {
        exec { "apt-key-add-${name}":
          command => "curl ${key_source} | apt-key add -",
          unless  => "apt-key list | grep `echo ${key}|tail -c 6` 2>/dev/null",
          notify  => Exec["apt-get-update-${name}"],
        }
      } elsif ($key_server) {
        exec { "apt-key-retrieve-${key}":
          command => "gpg --keyserver ${key_server} --recv-key ${key}",
          unless  => "gpg --list-key ${key}",
        }

        exec { "apt-key-add-${name}":
          command => "gpg -a --export ${key} | apt-key add -",
          unless  => "apt-key list | grep `echo ${key}|tail -c 6` 2>/dev/null",
          require => Exec["apt-key-retrieve-${key}"],
          notify  => Exec["apt-get-update-${name}"],
        }
      }
    } else {
      exec { "apt-key-remove-${name}":
        command => "apt-key del ${key}",
        onlyif  => "apt-key list | grep `echo ${key}|tail -c 6` 2>/dev/null",
      }
    }
  }

  exec { "apt-get-update-${name}":
    command     => "apt-get update",
    refreshonly => true,
  }
}
