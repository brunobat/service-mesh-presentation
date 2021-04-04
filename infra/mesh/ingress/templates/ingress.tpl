Kind = "ingress-gateway"
Name = "ingress-service"

Listeners = [
{{ with $services := (env "CONSUL_INGRESS_SERVICES" | parseYAML) }}
{{ range $services }}
 {
   Port = "{{ .PORT }}"
   Protocol = "{{ .PROTOCOL }}"
   Services = [
      {
        Name = "{{ .NAME }}"
      },
   ]
 },
{{ end }}
{{ end }}
]
