class php {
  package { [
    "php",
    "php-pear",
    "php-common",
    "php-gd",
    "php-cli",
    "php-snmp",
    "php-ldap",
    "php-curl",
    "php-json",
    "libapache2-mod-php",
    "php-gmp"
  ]:
    ensure => "latest",
  }
}
