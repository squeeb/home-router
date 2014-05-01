class samba::config(
  $workgroup,
  $server_string = $::fqdn,
  $shares = {}
){

  file { "/etc/samba/smb.conf":
    ensure => "file",
    owner => "root",
    group => "root",
    mode => "0644",
    notify => Service["smbd"],
    require => Package["samba"],
    content => template("samba/smb.conf.erb"),
  }

}
