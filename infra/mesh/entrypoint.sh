#!/bin/bash
# Modfied source from https://github.com/nicholasjackson/docker-consul-envoy/blob/master/entrypoint.sh for our use case

export SERVICE_ADDRESS=$(hostname -i)
# Wait until Consul can be contacted
until curl -s -k ${CONSUL_HTTP_ADDR}/v1/status/leader | grep 8300; do
  echo "Waiting for Consul to start"
  sleep 1
done
# Template the file out
# If we do not need to register a service just run the command
if [ ! -z "$SERVICE_CONFIG" ]; then
  # register the service with consul
  consul-template -once -template "$SERVICE_CONFIG.tpl:$SERVICE_CONFIG.hcl" 
  cat $SERVICE_CONFIG.hcl
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

# register any central config from a folder
if [ ! -z "$CENTRAL_CONFIG_DIR" ]; then
  for file in `ls -v $CENTRAL_CONFIG_DIR/*.tpl`; do 
    consul-template -once -template "$file:$file.hcl"
    echo "Writing central config $file.hcl"
    consul config write $file.hcl
    echo ""

    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      echo "### Error writing central config: $file ###"
      cat $file
      echo ""
      exit 1
    fi
  done
   trap clear_consul_central_config SIGINT SIGTERM EXIT
fi

clear_consul_central_config(){
  # Clear all consul central config supported Kinds

  #Ingress Gateway - defines the configuration for an ingress gateway
  # ingress-gateway
  for i in $(consul config list --kind ingress-gateway ); do
    consul config delete --kind ingress-gateway --name $i
  done
  #Proxy Defaults - controls proxy configuration
  # proxy-default
  for i in $(consul config list --kind proxy-default ); do
    consul config delete --kind proxy-default --name $i
  done
  #Service Defaults - configures defaults for all the instances of a given service
  # service-defaults
  for i in $(consul config list --kind service-defaults ); do
    consul config delete --kind service-defaults --name $i
  done
  #Service Intentions - defines the intentions for a destination service
  # service-intentions
  for i in $(consul config list --kind service-intentions ); do
    consul config delete --kind service-intentions --name $i
  done
  #Service Resolver - matches service instances with a specific Connect upstream discovery requests
  # service-resolver
  for i in $(consul config list --kind service-resolver ); do
    consul config delete --kind service-resolver --name $i
  done
  #Service Router - defines where to send layer 7 traffic based on the HTTP route
  # service-router
  for i in $(consul config list --kind service-router ); do
    consul config delete --kind service-router --name $i
  done
  #Service Splitter - defines how to divide requests for a single HTTP route based on percentages
  # service-splitter
  for i in $(consul config list --kind service-splitter ); do
    consul config delete --kind service-splitter --name $i
  done
  #Terminating Gateway - defines the services associated with terminating gateway
  # terminating-gateway
  for i in $(consul config list --kind terminating-gateway ); do
    consul config delete --kind terminating-gateway --name $i
  done
  # Remove all outputted values from templates
  for file in `ls -v $CENTRAL_CONFIG_DIR/*.hcl`; do
    rm $file
  done
}

# Run the command if specified
if [ "$#" -ne 0 ]; then
  echo "Running command: $@"
  exec "$@" &

  # Block using tail so the trap will fire
  tail -f /dev/null &
  PID=$!
  wait $PID
fi
