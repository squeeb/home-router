class apt::update {
  exec { "apt-get update":
    schedule => "bidaily",
  }
}
