# Monitoring

Monitoring is part of the default Docker Compose stack.

The setup follows the official `itzg/mc-monitor` Prometheus example:

- `monitor` runs `itzg/mc-monitor` and exports Minecraft status metrics.
- `cadvisor` exports Docker container metrics.
- `prometheus` stores time-series data.
- `grafana` provides dashboards.
- `spark` remains a Minecraft diagnostics tool for profiling and health reports.

## Access

Grafana is bound to VPS localhost only:

```text
127.0.0.1:3000
```

Open it through an SSH tunnel:

```sh
ssh -L 3000:127.0.0.1:3000 <user>@<vps-host>
```

Then open:

```text
http://localhost:3000
```

## Configuration

Set these values in the VPS `.env`:

```sh
GRAFANA_ADMIN_PASSWORD=change-me
GRAFANA_ADMIN_USER=admin
GRAFANA_PORT=3000
PROMETHEUS_RETENTION=7d
```

Only `GRAFANA_ADMIN_PASSWORD` is required. The other values have defaults.

Grafana update checks, usage reporting, and plugin preinstall behavior are disabled in Compose to keep startup logs deterministic and avoid downloading unused bundled plugins.

## Metrics

`mc-monitor` exports:

- `minecraft_status_healthy`
- `minecraft_status_response_time_seconds`
- `minecraft_status_players_online_count`
- `minecraft_status_players_max_count`

`cadvisor` exports container CPU, memory, disk IO, and network metrics.

cAdvisor mounts `/dev/kmsg` read-only so it can detect container OOM events when the host exposes that device. The repeated `There are no NVM devices!` message is harmless on hosts without persistent memory devices.

## Voice Chat

Simple Voice Chat uses UDP `24454` by default:

```sh
VOICE_CHAT_PORT=24454
```

Compose publishes `${VOICE_CHAT_PORT:-24454}:24454/udp`. Allow UDP `24454` in the VPS firewall and provider firewall if players should use voice chat.

## Commands

Start or update the full stack:

```sh
docker compose pull
docker compose up -d
```

Follow monitoring logs:

```sh
docker compose logs -f monitor prometheus grafana cadvisor
```

Check the raw Minecraft metrics endpoint from the VPS:

```sh
docker compose exec prometheus wget -qO- http://monitor:8080/metrics
```

## spark Diagnostics

Use `spark` when the server is lagging and you need a profiling report:

```text
/spark health
/spark tps
/spark profiler start --timeout 300
```

`spark` reports are diagnostic snapshots. Grafana is the always-on time-series dashboard.
