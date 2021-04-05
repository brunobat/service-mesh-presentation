kind = "service-splitter",
name = "superheroes"

splits = [
  {
    weight = 36,
    service_subset = "v1"
  },
  {
    weight = 64,
    service_subset = "v2"
  }
]
