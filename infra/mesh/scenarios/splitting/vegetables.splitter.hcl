kind = "service-splitter",
name = "vegetables"

splits = [
  {
    weight = 64,
    service_subset = "v1"
  },
  {
    weight = 36,
    service_subset = "v2"
  }
]
