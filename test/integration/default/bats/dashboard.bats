# vim: ft=sh:

@test "image-api is running" {
  netstat -tan | grep 9292
}

@test "image-registry is running" {
  netstat -tan | grep 9191
}
