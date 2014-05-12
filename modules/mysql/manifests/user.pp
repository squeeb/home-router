define mysql::user(
  $ensure = "present",
  $password,
  $database) {
  case $ensure {
    "present": {
      exec { "mysql_create_user_${name}":
        command => "mysql -uroot -e \"GRANT ALL ON ${database}.* TO '${name}'@'%' IDENTIFIED BY '${password}' WITH GRANT OPTION; FLUSH PRIVILEGES;\"",
        unless  => "mysqladmin -u${name} -p${password} status",
        require => [
          Service["mysql"],
        ],
      }
    }
    "absent": {
      exec { "mysql_delete_user_${name}":
        command => "mysql -uroot -e \"DROP USER '${name}'@'%'; FLUSH PRIVILEGES;\"",
        onlyif  => "mysqladmin -u${name} -p${password} status",
        require => [
          Service["mysql"],
        ],
      }
    }
  }
}
