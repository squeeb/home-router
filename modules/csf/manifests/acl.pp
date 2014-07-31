define csf::acl(
  $ensure = "present",
  $ports = [],
  $direction = "in",
  $protocol = "tcp",
  $host = "0.0.0.0/0"
) {
  file { "/etc/csf/conf.d/${name}.allow":
    content => template("csf/acl.allow.erb"),
    owner => "root",
    group => "root",
    mode => "0644",
    require => File["/etc/csf/conf.d"],
    ensure => $ensure ? {
      "present" => "file",
      "absent" => "absent",
    },
    notify => Service["csf"],
  }

  file_line { "csf_acl_${name}":
    path => "/etc/csf/csf.acl.allow",
    line => "Include /etc/csf/conf.d/${name}.allow",
    ensure => $ensure,
    require => File["/etc/csf/conf.d"],
    notify => Service["csf"],
  }
}
