class vsftpd {
  package { 'vsftpd':
    ensure => latest,
  }

  file { '/etc/vsftpd.conf':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('vsftpd/vsftpd.conf.erb'),
    require => Package['vsftpd'],
  }

  service { 'vsftpd':
    ensure  => running,
    enable  => true,
    require => File['/etc/vsftpd.conf'],
  }
}
