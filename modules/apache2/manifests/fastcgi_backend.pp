define apache2::fastcgi_backend(
  $host,
  $enabled = true,
) {

  $ensure = $enabled ? {
    true    => "file",
    false   => "absent",
    default => "file",
  }

  file { "/etc/apache2/conf-available/${name}.conf":
    ensure  => $ensure,
    owner   => "root",
    group   => "root",
    mode    => "0660",
    content => inline_template("FastCGIExternalServer /var/www/${name}.fcgi -host ${host}\n\n"),
    notify  => [
      Service["apache2"],
      Exec["a2enconf ${name}"],
    ],
  }

  exec { "a2enconf ${name}":
    refreshonly => true,
    creates     => "/etc/apache2/conf-enabled/${name}.conf",
    notify      => Service["apache2"],
  }

}
