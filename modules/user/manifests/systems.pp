class user::systems {
  $system_users = hiera("users::system_users")
  create_resources("user::system", $system_users)
}
