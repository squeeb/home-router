class postfix::cron::mail_queue_checker {
  file { '/usr/local/bin/mail_queue_checker':
    ensure  => 'absent',
  }

  cron { 'sendmail_mail_queue_checker':
    ensure => 'absent',
    command => '/usr/local/bin/mail_queue_checker',
    user => 'root',
    hour => 7,
    minute => 4,
    require => File['/usr/local/bin/mail_queue_checker'],
  }
}
