service {
  name = "{{ env "CONSUL_SERVICE_NAME" }}"
  id = "{{ env "CONSUL_SERVICE_ID" }}"
  address = "{{ env "SERVICE_ADDRESS" }}"
  port = {{ env "CONSUL_SERVICE_PORT" }}
  
  connect {
    sidecar_service {
    port = 20000
    check {
        name = "Connect Envoy Sidecar"
        tcp = "{{ env "SERVICE_ADDRESS" }}:20000"
        interval ="10s"
      }
    {{ if (env "CONSUL_PROXY_UPSTREAMS") }}
    proxy {
    {{ with $upstreams := (env "CONSUL_PROXY_UPSTREAMS" | parseYAML) }}
    {{ range $upstreams }}
      upstreams {
        destination_name = "{{ .DESTINATION_NAME }}"
        local_bind_address = "{{ .LOCAL_BIND_ADDRESS }}"
        local_bind_port = {{ .LOCAL_BIND_PORT }}
      }
    {{ end }}
    {{ end }}
    }
    {{ end }}
    }  
  }
}
