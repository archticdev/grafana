# Get the directory of this Makefile
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: apm grafana apm-remote grafana-remote apm-down grafana-down

grafana apm:
	@cd $(MAKEFILE_DIR) && RUNNING_MODE=local docker compose --profile local up -d

grafana-remote apm-remote:
	@cd $(MAKEFILE_DIR) && RUNNING_MODE=remote docker compose --profile remote up -d

grafana-down apm-down:
	@cd $(MAKEFILE_DIR) && docker compose down
