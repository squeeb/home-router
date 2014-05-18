hiera_include("classes")
Exec { path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" }
File { backup => false }

schedule { "bidaily":
  period => "daily",
  repeat => 2,
}

stage { "bootstrap":
  before => Stage["main"],
}

class { "resolv":
  stage => "bootstrap",
}

class { "repo":
  stage => "bootstrap",
  require => Class["resolv"],
}

case $operatingsystem {
  /^(Debian|Ubuntu)$/: {
    class { "apt::update":
      stage    => "bootstrap",
      require  => Class["repo"],
    }
  }
}
