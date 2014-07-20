class java {

  $java_package_name = $operatingsystem ? {
    /^(Ubuntu|Debian)$/ => "oracle-java7-set-default",
    "CentOS"            => "java",
  }

  package { "java":
    name   => $java_package_name,
    ensure => "installed",
  }

}
