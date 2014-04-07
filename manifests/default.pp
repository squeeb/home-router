hiera_include("classes")
import '/etc/puppet/nodes/*.pp'
File { backup => false }
