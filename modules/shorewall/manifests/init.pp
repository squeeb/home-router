class shorewall {

  $zones = hiera("shorewall::zones")
  $policies = hiera("shorewall::policies")

  package { "shorewall":
    ensure => "latest",
  }

  file { "/etc/shorewall/zones":
    ensure  => "file",
    owner   => "root",
    group   => "root",
    mode    => "0640",
    content => template("shorewall/zones.erb"),
    require => Package["shorewall"],
  }

  file { "/etc/shorewall/policy":
    ensure  => "file",
    owner   => "root",
    group   => "root",
    mode    => "0640",
    content => template("shorewall/policy.erb"),
    require => Package["shorewall"],
  }
}
