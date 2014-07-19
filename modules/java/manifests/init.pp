class java {

  $java_package_name = $operatingsystem ? {
    /^(Ubuntu|Debian)$/ => "openjdk-7-jre",
    "CentOS"            => "java",
  }

  package { "java":
    name   => $java_package_name,
    ensure => "installed",
  }

}
