kind = "service-router"
name = "api"
routes = [
  {
    match {
      http {
        path_prefix = "/vegetables"
      }
    }

    destination {
      service = "vegetables"
    }
  },
  {
    match {
      http {
        path_prefix = "/superheroes"
      }
    }

    destination {
      service = "superheroes"
    }
  },
]
