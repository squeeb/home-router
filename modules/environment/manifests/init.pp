class environment {
  file { "/usr/local/bin/puppet-run":
    ensure => "present",
    content => template("environment/puppet-run.sh.erb"),
    owner => "root",
    group => "root",
    mode => "0755",
  }
}
