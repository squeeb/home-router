class mountpoints {

  file { "/mnt/data":
    ensure => "directory",
    path => "/mnt/data",
    mode => "0755",
    owner => "root",
    group => "root",
  }

  $mountpoints = hiera_hash("mountpoints",{})
  create_resources("mountpoints::mount", $mountpoints, { require => File["/mnt/data"] })

}


