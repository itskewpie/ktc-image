# vim: ft=sh:

@test "image-api registered with etcd" {
  curl http://127.0.0.1:4001/v1/keys/services/image-api/members
}

@test "image-registry registered with etcd" {
  curl http://127.0.0.1:4001/v1/keys/services/image-registry/members
}

@test "image-api is running" {
  netstat -tan | grep 9292
}

@test "image-registry is running" {
  netstat -tan | grep 9191
}
