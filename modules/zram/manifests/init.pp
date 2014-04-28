class zram {
  file { "/etc/modprobe.d/zram.conf":
    ensure => "file",
    content => "options zram num_devices=${processorcount}",
    owner => "root",
    group => "root",
    mode => "0664",
    notify => Service["zram"],
  }

  file { "/etc/init.d/zram":
    ensure => "file",
    source => "puppet:///modules/zram/zram.init",
    owner => "root",
    group => "root",
    mode => "0755",
    notify => Service["zram"],
  }

  service { "zram":
    ensure => "running",
    enable => true,
    require => File[
      "/etc/modprobe.d/zram.conf",
      "/etc/init.d/zram"
    ],
  }
}
