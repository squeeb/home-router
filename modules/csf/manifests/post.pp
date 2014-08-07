class csf::post {
  $post_cmds = hiera_array("csf::post_cmds", [])

  file { "/etc/csf/csfpost.sh":
    ensure => "file",
    mode => "0700",
    owner => "root",
    group => "root",
    content => template("csf/csfpost.sh.erb"),
    require => Exec["build-csf"],
    notify => Service["csf"],
  }
}
