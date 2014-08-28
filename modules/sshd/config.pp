class sshd::config($port = 22) {

  $service = $operatingsystem ? {
    /^(Debian|Ubuntu)$/ => "ssh",
    /^(RedHat|CentOS)$/ => "sshd",
  }

  service { $service:
    ensure => "running",
    enable => true,
  }

  file_line { "ssh_port":
    path => "/etc/ssh/sshd_config",
    line => "Port ${port}",
    ensure => "present",
    notify => Service["ssh"],
  }
}
