class php5 {
  package { [
    "php5",
    "php-pear",
    "php5-common",
    "php5-gd",
    "php5-cli",
    "php5-snmp",
    "php5-ldap",
    "php5-curl",
    "php5-json",
    "php5-mcrypt",
    "libapache2-mod-php5",
    "php5-gmp"
  ]:
    ensure => "latest",
  }
}
