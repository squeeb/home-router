class seafile($version) {

  package {[
    "python-flup",
    "python-imaging",
    "python-mysqldb"
  ]:
    ensure => "installed",
  }

  exec { "get-seafile":
    cwd => "/opt/seafile",
    command => "wget https://bitbucket.org/haiwen/seafile/downloads/seafile-server_${version}_x86-64.tar.gz -O /opt/seafile/installed/seafile-server_${version}_x86-64.tar.gz",
    creates => "/opt/seafile/installed/seafile-server_${version}_x86-64.tar.gz",
    require => File["/opt/seafile/installed"],
  }

  exec { "extract-seafile":
    cwd => "/opt/seafile",
    command => "tar zxf /opt/seafile/installed/seafile-server_${version}_x86-64.tar.gz -C /opt/seafile && chown -R cloud /opt/seafile",
    creates => "/opt/seafile/seafile-server-${version}/seafile.sh",
    require => [
      Exec["get-seafile"],
      File["/opt/seafile"],
    ],
  }

  file {[
    "/data/seafile",
    "/opt/seafile",
    "/opt/seafile/installed"
  ]:
    ensure => "directory",
    owner => "cloud",
    group => "root",
    mode => "6770",
    require => User["cloud"],
  }

  file { "/etc/apache2/sites-available/seafile.conf":
    ensure  => "file",
    mode    => "0660",
    owner   => "root",
    group   => "www-data",
    content => template("seafile/apache2.conf.erb"),
    notify  => Exec["a2ensite seafile"],
    require => Package["apache2"],
  }

  exec { "a2ensite seafile":
    refreshonly => true,
    creates     => "/etc/apache2/sites-enabled/seafile.conf",
    notify      => Service["apache2"],
  }

  user { "cloud":
    ensure => "present",
    comment => "Private cloud services",
    system => true,
  }
}
