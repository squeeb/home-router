node default {

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
}
