define mysql::database($ensure = "present") {
  case $ensure {
    "present": {
      exec { "mysql_create_database_${name}":
        command => "mysqladmin create ${name} -uroot",
        unless => "echo 'use ${name}' | mysql -uroot",
        require => Service["mysql"],
      }
    }
    "absent": {
      exec { "mysql_drop_database_${name}":
        command => "yes | mysqladmin drop ${name} -uroot",
        onlyif => "echo 'use ${name}' | mysql -uroot",
        require => Service["mysql"],
      }
    }
  }
}
