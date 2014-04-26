class resolv {
  $resolvers = hiera("resolv::resolvers")
  $search = hiera_array("resolv::search")
  $options = hiera("resolv::options")

  file { "/etc/resolv.conf":
    owner => "root",
    group => "root",
    mode => "0644",
    content => template("resolv/resolv.conf.erb"),
  }
}
