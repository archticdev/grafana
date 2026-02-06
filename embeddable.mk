# Get the directory of this Makefile
GRAFANA_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

grafana:

.PHONY: grafana grafana-remote grafana-down

grafana: grafana-config
	@cd $(GRAFANA_DIR) && RUNNING_MODE=local docker compose --profile local up -d

$(GRAFANA_DIR)/docker-compose.yml: $(GRAFANA_DIR)/docker-compose.network.yml $(GRAFANA_DIR)/docker-compose.template.yml
	@cd $(GRAFANA_DIR) && ./generate.sh

grafana-config: $(GRAFANA_DIR)/docker-compose.yml

grafana-remote grafana-dev:
	@cd $(GRAFANA_DIR) && RUNNING_MODE=remote docker compose --profile remote up -d

grafana-down:
	@cd $(GRAFANA_DIR) && docker compose --profile local --profile remote down