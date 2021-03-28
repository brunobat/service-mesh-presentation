services {
  name = "vegetables"
  port = 8080

  connect {
    sidecar_service {
      proxy {
        upstreams {
          destination_name   = "superheroes"
          local_bind_address = "127.0.0.2"
          local_bind_port    = 8080
        }
      }
    }
  }
}

services {
  name = "superheroes"
  port = 8080

  connect {
    sidecar_service {}
  }
}
