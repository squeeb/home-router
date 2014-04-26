class hosts {

  $host_aliases = hiera_hash("host_aliases",{})
  create_resources("host", $host_aliases)

}
