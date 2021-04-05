Kind          = "service-resolver"
Name          = "superheroes"
DefaultSubset = "v1"
Subsets = {
  "v1" = {
    filter = "\"v1\" in Service.Tags"
  }
  "v2" = {
    filter = "\"v2\" in Service.Tags" 
  }
}
