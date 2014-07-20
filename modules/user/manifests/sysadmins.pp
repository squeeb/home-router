class user::sysadmins {

  $sysadmins = hiera_hash("users::sysadmins")
  create_resources("user::standard", $sysadmins)

}
