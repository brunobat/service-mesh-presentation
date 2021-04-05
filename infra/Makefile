create_simple_routing_scenario:
	consul config write mesh/scenarios/routing/api.router.hcl

create_header_routing_scenario:
	consul config write mesh/scenarios/routing/api.router.header.hcl

call_routing_vegetables_scenario:
	curl -v -L -H "Host: api.ingress.dc1.consul:8080" http://localhost:8080/vegetables/q/health

call_routing_superheroes_scenario:
	curl -v -L -H "Host: api.ingress.dc1.consul:8080" http://localhost:8080/superheroes/q/health

create_resolver_scenario:
	consul config write mesh/scenarios/resolver/superheroes.resolver.hcl
	consul config write mesh/scenarios/routing/vegetables.resolver.hcl
	consul config write mesh/scenarios/routing/api.router.hcl

call_resolver_vegetables_scenario:
	curl -v -L -H "Host: api.ingress.dc1.consul:8080" http://localhost:8080/vegetables/q/health

call_resolver_superheroes_scenario:
	curl -v -L -H "Host: api.ingress.dc1.consul:8080" http://localhost:8080/superheroes/q/health

create_splitting_scenario:
	consul config write mesh/scenarios/splitting/superheroes.resolver.hcl
	consul config write mesh/scenarios/splitting/vegetables.resolver.hcl
	consul config write mesh/scenarios/splitting/superheroes.splitter.hcl
	consul config write mesh/scenarios/splitting/vegetables.splitter.hcl
	consul config write mesh/scenarios/splitting/api.router.hcl

call_splitting_vegetables_scenario:
	curl -v -L -H "Host: api.ingress.dc1.consul:8080" http://localhost:8080/vegetables/q/health

call_splitting_superheroes_scenario:
	curl -v -L -H "Host: api.ingress.dc1.consul:8080" http://localhost:8080/superheroes/q/health

create_intentions_disallow_scenario:
	consul config write mesh/scenarios/intentions/database.disallow.hcl
	consul config write mesh/scenarios/intentions/full.disallow.hcl

create_intentions_allow_scenario:
	consul config write mesh/scenarios/intentions/database.allow.hcl
	consul config write mesh/scenarios/intentions/full.allow.hcl
