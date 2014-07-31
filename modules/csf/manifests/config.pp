class csf::config(
  $icmp_in = true,
  $filter_ipv6 = false,
  $tcp_in = [],
  $udp_in = [],
  $interfaces = [],
  $skip_interfaces = [],
  $nf_conntrack = true,
  $filter_synflood = true,
  $synflood_burst = 500,
  $synflood_rate = 100,
  $eth_device = undef,
  $cc_lookups = 0,
  $account_tracking = 2,
  $ssh_failed_login_threshold = 5,
  $ssh_block_expire = 300,
) {

  $system_log = $operatingsystem ? {
    /(CentOS|RedHat)/ => "/var/log/messages",
    /(Debian|Ubuntu)/ => "/var/log/syslog",
  }

  $allow_acls = hiera_array("csf::config::acls::allow", [])

  file { "/etc/csf/conf.d":
    ensure => "directory",
    owner => "root",
    group => "root",
    mode => "0700",
    require => Exec["build-csf"],
  }

  file { "/etc/csf/csf.acl.allow":
    ensure => "file",
    owner => "root",
    group => "root",
    mode => "0640",
    require => Exec["build-csf"],
  }

  file { "/etc/csf/csf.conf":
    ensure => "file",
    owner => "root",
    group => "root",
    mode => "0640",
    content => template("csf/csf.conf.erb"),
    require => Exec["build-csf"],
    notify => Service["csf", "lfd"],
  }

  file { "/etc/csf/csf.allow":
    ensure => "file",
    owner => "root",
    group => "root",
    mode => "0640",
    content => template("csf/csf.allow.erb"),
    require => File["/etc/csf/csf.conf"],
    notify => Service["csf"],
  }
}
