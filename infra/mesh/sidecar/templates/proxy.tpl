service {
  name = "{{ env "CONSUL_SERVICE_NAME" }}"
  id = "{{ env "CONSUL_SERVICE_ID" }}"
  address = "{{ env "SERVICE_ADDRESS" }}"
  port = {{ env "CONSUL_SERVICE_PORT" }}
  {{ if (env "CONSUL_TAGS") }}
  {{ with $tags := (env "CONSUL_TAGS" | parseYAML) }}
  tags = [{{ range $tags }}"{{ . }}",{{ end }}] 
  {{ end }}{{ end }}
  connect {
    sidecar_service {
    port = 20000
    checks = [
      { 
        name = "Connect Envoy Sidecar {{ env "CONSUL_SERVICE_NAME" }}"
        tcp = "{{ env "SERVICE_ADDRESS" }}:20000"
        interval ="10s"
      },
      {{ if (env "CONSUL_CHECKS") }}
      {{ with $checks := (env "CONSUL_CHECKS" | parseYAML) }}
      {{ range $checks }}
      {
        name = "{{ env "CONSUL_SERVICE_NAME" }} {{ .NAME }} healtcheck"
        http = "http://{{ env "SERVICE_ADDRESS" }}:{{ env "CONSUL_SERVICE_PORT" }}{{ .PATH }}"
        interval ="{{ .INTERVAL }}"
      },
      {{ end }}
      {{ end }}
      {{ end }}
    ]
    {{ if (env "CONSUL_PROXY_UPSTREAMS") }}
    proxy {
     expose {
      checks = true
      }
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
