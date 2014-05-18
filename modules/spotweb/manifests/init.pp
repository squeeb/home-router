class spotweb {
  $spotweb_db_host = hiera("spotweb::config::spotweb_db_host")
  $spotweb_db_name = hiera("spotweb::config::spotweb_db_name")
  $spotweb_db_user = hiera("spotweb::config::spotweb_db_user")
  $spotweb_db_pass = hiera("spotweb::config::spotweb_db_pass")
  $sysadmin_email_address = hiera("sysadmin::email_address")

  file { "/usr/share/spotweb":
    ensure => "directory",
    owner => "root",
    group => "www-data",
    mode => "0750",
    require => Package["apache2"],
  }

  file { "/usr/share/spotweb/cache":
    ensure => "directory",
    owner => "www-data",
    group => "www-data",
    mode => "0770",
    require => File["/usr/share/spotweb"],
  }

  exec { "install-spotweb":
    command => "git clone https://github.com/spotweb/spotweb.git /usr/share/spotweb",
    creates => "/usr/share/spotweb/README.md",
    require => File["/usr/share/spotweb"],
  }

  file { "/etc/apache2/conf.d/spotweb.conf":
    ensure => "absent",
  }

  file { "/etc/apache2/sites-available/spotweb.conf":
    ensure => "file",
    owner => "root",
    group => "root",
    mode => "0644",
    source => "puppet:///modules/spotweb/apache/spotweb.conf",
    require => [
      File["/etc/php5/apache2/php.ini"],
      Package[
        "apache2",
        "php5"
      ]
    ],
    notify => Service["apache2"],
  }

  file { "/etc/apache2/sites-enabled/spotweb.conf":
    ensure => "link",
    target => "/etc/apache2/sites-available/spotweb.conf",
    require => File["/etc/apache2/sites-available/spotweb.conf"],
    notify => Service["apache2"],
  }

  mysql::database { $spotweb_db_name:
    ensure => "present",
  }

  mysql::user { $spotweb_db_user:
    ensure => "present",
    database => $spotweb_db_name,
    password => $spotweb_db_pass,
    require => Mysql::Database[$spotweb_db_name],
  }

  file { "/usr/share/spotweb/dbsettings.inc.php":
    owner => "root",
    group => "www-data",
    mode => "0640",
    content => template("spotweb/dbsettings.erb"),
    require => [
      Mysql::User[$spotweb_db_user],
      Exec["install-spotweb"]
    ],
  }

  cron { "spotweb-retrieve":
    command => "cd /usr/share/spotweb && /usr/bin/php retrieve.php | mail -s spotweb-retrieve ${sysadmin_email_address}",
    user    => "www-data",
    hour    => "*/12",
    minute  => 32,
    require => File["/usr/share/spotweb/dbsettings.inc.php"],
  }
}
