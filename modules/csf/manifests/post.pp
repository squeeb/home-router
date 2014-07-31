class csf::post {
  file { "/etc/csf/csfpost.sh":
    ensure => "file",
    mode => "0700",
    owner => "root",
    group => "root",
    source => "puppet:///modules/csf/${::role}/csfpost.sh",
    require => Exec["build-csf"],
    notify => Service["csf"],
  }
}
