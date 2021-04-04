service {
  name = ""
  id = ""
  address = ""
  port = 
  
  connect {
    sidecar_service {
    port = 20000
    check {
        name = "Connect Envoy Sidecar"
        tcp = ":20000"
        interval ="10s"
      }
    
    }  
  }
}
