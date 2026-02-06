# Grafana Stack

This repository provides a complete monitoring solution with Grafana, Prometheus, Loki, Tempo, and Alloy, configurable for both local and remote deployment scenarios.

## Features

- 🚀 **Quick Setup** - Single command to start the full stack
- 🔌 **Embeddable** - Include in other projects via `embeddable.mk`
- 🌐 **Dual Mode** - Run full stack locally or hybrid remote setup
- 🔧 **Template-Based** - Customizable network configuration
- 📊 **Complete Stack** - Metrics, logs, and traces out of the box

## Components

The stack includes:

- **Grafana** - Visualization and dashboards (`:3000`)
- **Alloy** - Telemetry collector (`:12345`)
- **Prometheus** - Metrics storage and querying (`:9090`)
- **Loki** - Log aggregation (`:3100`)
- **Tempo** - Distributed tracing (`:3200`)
- **Node Exporter** - Host metrics collection

## Deployment Modes

### Local Mode (Full Stack)

Runs the complete observability stack locally for standalone development and testing.

```bash
make
```

```
┌────────────────────────────┐
│      Your Application      │
└───-──────────┬──-──────────┘
               │ (metrics/logs/traces)
               ▼
          ┌─────────┐
          │  Alloy  │
          └────┬────┘
               │
     ┌──────-──┼────────┐
     ▼         ▼        ▼
┌───────-──┐ ┌────┐ ┌───────┐
│Prometheus│ │Loki│ │ Tempo │
└────┬──-──┘ └─┬──┘ └───┬───┘
     │         │        │
     └────────-┼────────┘
               ▼
          ┌─────────┐
          │ Grafana │
          └─────────┘
```

### Remote Mode (Hybrid)

Runs **only Alloy locally** as a telemetry collector, publishing to a remote Grafana stack. 
This is ideal for offloading processing to a remote environment using [Bifrost](https://github.com/archticdev/bifrost) for simple SSH tunneling.

```bash
make remote
```

```
┌───────────────────────────────────────┐
│         Your Local Environment        │
│     ┌──────────────────────────┐      │
│     │     Your Application     │      │
│     └───────────┬──---─────────┘      │
│                 │                     │
│                 ▼                     │
│            ┌─────────┐                │
│            │  Alloy  │                │
│            └────┬────┘                │
└───────-─────────┼─────────────────────┘
                  │
                  │ (via SSH tunnel)
                  │
┌───────-─────────▼─────────────────────┐
│       Remote Grafana Stack            │
│  ┌─────---──┐  ┌────┐  ┌─────┐        │
│  │Prometheus│  │Loki│  │Tempo│        │
│  └───┬──---─┘  └─┬──┘  └──┬──┘        │
│      └─---───────┼────────┘           │
│                  ▼                    │
│             ┌─────────┐               │
│             │ Grafana │               │
│             └─────────┘               │
└───────────────────────────────────────┘
```

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Make

### Standalone Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/archticdev/grafana.git
   cd grafana
   ```

2. Start the stack:
   ```bash
   make
   ```

3. Access Grafana at [http://localhost:3000](http://localhost:3000)

4. Stop the stack:
   ```bash
   make down
   ```

### Embedded Usage

Include this stack in your project's Makefile:

```makefile
include path/to/grafana/embeddable.mk
```

Then use the provided targets:

```makefile
# Start full local stack
make grafana

# Start remote mode (Alloy only)
make grafana-remote

# Stop all services
make grafana-down
```

## Configuration

### Network Configuration

The stack uses a template-based system for network configuration. By default, it uses a network named `common`.

To customize the network:

1. Edit `docker-compose.network.yml`:
   ```yaml
   networks:
       your-network-name:
           external: true
   ```

2. Regenerate the compose file:
   ```bash
   make config
   ```

### Alloy Configuration

Edit `config.alloy` to configure telemetry collection pipelines. The configuration supports discovery, scraping, and forwarding of metrics, logs, and traces.

### Data Source Provisioning

Pre-configured data sources are in `provisioning/datasources/`:
- `prometheus-ds.yml` - Prometheus metrics
- `loki-ds.yml` - Loki logs
- `tempo-ds.yaml` - Tempo traces

## Use Cases

- **Local Development** - Full stack for developing and testing observability pipelines
- **Team Collaboration** - Remote mode for sharing a centralized Grafana instance
- **CI/CD Testing** - Embed in test environments for integration testing
- **Microservices** - Include as a submodule in microservice projects
- **Learning** - Explore Grafana, Prometheus, Loki, and Tempo without complex setup

## Tips

- **Customize Alloy**: Edit `config.alloy` to add custom discovery and scraping rules
- **Persistent Data**: Volumes are created for data persistence across restarts

## Troubleshooting

### Generated compose file not found

Run `make config` to generate `docker-compose.yml`.

### Network not found

Ensure the network defined in `docker-compose.network.yml` exists.
```bash
docker network create common
```
Alternatively, set `external: false` to let Docker Compose create it automatically.

### Services won't start

Check logs for specific services:
```bash
docker compose logs <service-name>
```

## Related Projects

- [Bifrost](https://github.com/archticdev/bifrost) - Simple SSH tunnel manager
