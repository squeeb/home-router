class user::sysadmins {

  $sysadmins = hiera("users::sysadmins")
  create_resources("user::standard", $sysadmins)

}
