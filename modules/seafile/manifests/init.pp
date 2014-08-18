class seafile {

  class { "apache2": }

  package {[
    "python-flup",
    "python-imaging",
    "python-mysqldb"
  ]:
    ensure => "installed",
  }

  exec { "get-seafile":
    cwd => "/opt/seafile",
    command => "wget https://bitbucket.org/haiwen/seafile/downloads/seafile-server_3.1.2_x86-64.tar.gz -O /opt/seafile/installed/seafile-server_3.1.2_x86-64.tar.gz",
    creates => "/opt/seafile/installed/seafile-server_3.1.2_x86-64.tar.gz",
    require => File["/opt/seafile/installed"],
  }

  exec { "extract-seafile":
    cwd => "/opt/seafile",
    command => "tar zxf /opt/seafile/installed/seafile-server_3.1.2_x86-64.tar.gz -C /opt/seafile && chown -R cloud /opt/seafile",
    creates => "/opt/seafile/seafile-server-3.1.2/seafile.sh",
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

  user { "cloud":
    ensure => "present",
    comment => "Private cloud services",
    system => true,
  }
}
