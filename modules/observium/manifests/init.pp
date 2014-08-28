class observium(
  $database_name,
  $database_user,
  $database_pass,
  $database_server,
  $poll_interval_minutes = 5,
) {
  $ro_community = hiera("snmp::community::ro", "public")
  $syscontact = hiera("snmp::syscontact","sysadmin@onthebeach.co.uk")

  user { "observium":
    ensure => "present",
    groups => "www-data",
    system => true,
  }

  file { "/opt/observium":
    ensure => "directory",
    owner => "observium",
    group => "www-data",
    require => User["observium"],
  }

  exec { "get observium":
    cwd => "/opt",
    command => "wget http://www.observium.org/observium-community-latest.tar.gz && tar zxvf observium-community-latest.tar.gz",
    creates => "/opt/observium-community-latest.tar.gz",
    require => [
      File["/opt/observium"],
      Package[
        "php-pear",
        "php5-common",
        "php5-gd",
        "php5",
        "php5-cli",
        "php5-mysql",
        "php5-snmp",
        "php5-ldap"
      ],
    ],
  }

  package { [
      "snmp",
      "graphviz",
      "fping",
      "imagemagick",
      "whois",
      "mtr-tiny",
      "nmap",
      "ipmitool",
      "python-mysqldb",
    ]:
    ensure => "latest",
  }

  package { "rrdtool":
    ensure => "latest",
  }

  package { "python-argparse":
    ensure => "installed",
  }

  file { "observium_config":
    path => "/opt/observium/config.php",
    ensure => "file",
    content => template("observium/config.php.erb"),
    require => Exec["get observium"],
    owner => "observium",
    group => "www-data",
    mode => "0770",
  }

  file { "observium_apache_config":
    path => "/etc/apache2/sites-enabled/observium.conf",
    ensure => "file",
    content => template("observium/observium.apache.conf.erb"),
    owner => "root",
    group => "root",
    notify => Service["apache2"],
  }

  file { [
    "/opt/observium/rrd",
    "/opt/observium/logs"
  ]:
    ensure => "directory",
    owner => "observium",
    group => "www-data",
    mode => "0775",
    require => Exec["get observium"],
  }

  cron { "observium_discovery_all":
    user => "observium",
    command => "/opt/observium/discovery.php -h all >> /dev/null 2>&1",
    minute => "33",
    hour => "*/6",
    require => Exec["get observium"],
  }

  cron { "observium_discovery_new":
    user => "observium",
    command => "/opt/observium/discovery.php -h new >> /dev/null 2>&1",
    minute => "*/${poll_interval_minutes}",
    require => Exec["get observium"],
  }

  cron { "observium_poller_wrapper":
    user => "observium",
    command => "/opt/observium/poller-wrapper.py 1 >> /dev/null 2>&1",
    minute => "*/${poll_interval_minutes}",
    require => [
      Exec["get observium"],
      Package[
        "python-argparse"
      ],
    ],
  }

  file { "/home/observium":
    ensure => "directory",
    owner => "observium",
    group => "www-data",
    mode => "6775",
    require => Exec["get observium"],
  }
}
