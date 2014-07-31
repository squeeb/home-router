class perl::time_hires {
  case $operatingsystem {
    'Debian': { $perltimehires = "libtime-hires-perl" }
    'CentOS': { $perltimehires = "perl-Time-HiRes" }
  }
  package { $perltimehires:
    ensure => installed,
  }
}
