FROM consul:1.9.4 as CONSUL
FROM hashicorp/consul-template:0.25.2-scratch as CONSUL_TEMPLATE
FROM envoyproxy/envoy-alpine:v1.16.0
COPY --from=CONSUL /bin/consul /bin/consul
COPY --from=CONSUL_TEMPLATE /consul-template /bin/consul-template
RUN apk add -u bash curl
COPY entrypoint.sh /entrypoint.sh
COPY ./sidecar/templates /sidecar/templates
COPY ./ingress/templates /ingress/templates
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
