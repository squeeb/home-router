class environment::profile {

  file { "/etc/profile.d/malkovich.sh":
    ensure => "absent",
    path => "/etc/profile.d/malkvich.sh",
  }

  file { "/etc/profile.d/prompt.sh":
    ensure  => "present",
    mode    => "0755",
    owner   => "root",
    group   => "root",
    content => template("environment/prompt.sh.erb"),
  }
}
