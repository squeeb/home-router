class perl::libwww {
  case $operatingsystem {
    /^(Debian|Ubuntu)$/: { $perllibwww = "libwww-perl" }
    'CentOS': {
      $perllibwww = "perl-libwww-perl"
      #CentOS doesn't pull in Crypt-SSLeay by default whereas in Debian it is a dependency and will be included with perl-libwww
      package { "perl-Crypt-SSLeay":
        ensure => installed,
      }
      package { "perl-Net-SSLeay":
        ensure => installed,
      }
    }
  }
  package { $perllibwww:
    ensure => installed,
  }
}
