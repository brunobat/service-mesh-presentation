kind = "service-router"
name = "vegetables"
routes = [
  {
    match {
      http {
        path_prefix = "/v1"
      }
    }

    destination {
      service = "vegetables"
    }
  },
  {
    match {
      http {
        path_prefix = "/"
      }
    }

    destination {
      service = "vegetables-v2"
    }
  },
]
