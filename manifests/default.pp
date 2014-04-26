hiera_include("classes")
import '/etc/puppet/nodes/*.pp'
Exec { path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" }
File { backup => false }
