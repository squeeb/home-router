class php5 {
  package { [
    "php5",
    "php5-curl",
    "php5-gd",
    "php5-json",
    "libapache2-mod-php5",
    "php5-gmp"
  ]:
    ensure => "latest",
  }
}
