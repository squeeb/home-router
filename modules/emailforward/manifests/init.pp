class emailforward {

  $sysadmin_email_address = hiera("sysadmin::email_address")

  file { "forward_file":
    path   => "/root/.forward",
    ensure => "file",
    owner  => "root",
    group  => "root",
    mode   => "0644",
    content => $sysadmin_email_address,
  }

}
