Exec {
  path        => '/usr/bin:/bin:/usr/sbin:/sbin',
  environment => 'RUBYLIB=/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.1.0/',
  logoutput   => true,
  timeout     => 180,
}
hiera_include("classes", [])
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
