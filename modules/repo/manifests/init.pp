class repo {
  case $operatingsystem {
    'CentOS', 'RedHat' : {
      $repos = hiera_hash("yumrepo::repos")

      file { [
        "/etc/yum.repos.d/CentOS-Base.repo",
        "/etc/yum.repos.d/CentOS-Debuginfo.repo",
        "/etc/yum.repos.d/CentOS-Media.repo",
        "/etc/yum.repos.d/CentOS-Vault.repo",
      ]:
        ensure => "absent",
      }

      create_resources("yumrepo", $repos, {
        require => File[
          "/etc/yum.repos.d/CentOS-Base.repo",
          "/etc/yum.repos.d/CentOS-Debuginfo.repo",
          "/etc/yum.repos.d/CentOS-Media.repo",
          "/etc/yum.repos.d/CentOS-Vault.repo"
        ]}
      )
    }
    'Debian' : {
      $repos = hiera_hash("apt::repos")
      create_resources("apt::repo", $repos)
    }
  }
}
