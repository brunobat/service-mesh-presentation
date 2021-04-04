#!/bin/bash
# Modfied source from https://github.com/nicholasjackson/docker-consul-envoy/blob/master/entrypoint.sh for our use case
set -e
SERVICE_CONFIG=/templates/sidecar
export SERVICE_ADDRESS=$(hostname -i)
# Wait until Consul can be contacted
until curl -s -k ${CONSUL_HTTP_ADDR}/v1/status/leader | grep 8300; do
  echo "Waiting for Consul to start"
  sleep 1
done
# Template the file out
consul-template -once -template "$SERVICE_CONFIG.tpl:$SERVICE_CONFIG.hcl" 
cat $SERVICE_CONFIG.hcl
# If we do not need to register a service just run the command
if [ ! -z "$SERVICE_CONFIG" ]; then
  # register the service with consul
  echo "Registering service with consul"
  consul services register ${SERVICE_CONFIG}.hcl
  exit_status=$?
  if [ $exit_status -ne 0 ]; then
    echo "### Error writing service config: $file ###"
    cat $file
    echo ""
    exit 1
  fi
  
  # make sure the service deregisters when exit
  trap "consul services deregister ${SERVICE_CONFIG}.hcl" SIGINT SIGTERM EXIT
fi

# Run the command if specified
if [ "$#" -ne 0 ]; then
  echo "Running command: $@"
  exec "$@" &

  # Block using tail so the trap will fire
  tail -f /dev/null &
  PID=$!
  wait $PID
fi
