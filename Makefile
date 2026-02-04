# Get the directory of this Makefile
GRAFANA_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: apm grafana apm-remote grafana-remote apm-down grafana-down

grafana apm:
	@cd $(GRAFANA_DIR) && RUNNING_MODE=local docker compose --profile local up -d

grafana-remote apm-remote:
	@cd $(GRAFANA_DIR) && RUNNING_MODE=remote docker compose --profile remote up -d

grafana-down apm-down:
	@cd $(GRAFANA_DIR) && docker compose --profile local --profile remote down
