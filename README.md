# AVR Asterisk Docker Image

This is a lightweight Asterisk 22.7.0 Docker image optimized for VoIP applications. The image is based on Ubuntu 22.04 and includes only essential modules and features.

## Features

- Asterisk 22.7.0
- PJSIP support
- Manager API enabled
- HTTP API enabled
- Prometheus metrics enabled
- Minimal footprint with only essential modules
- Timezone set to Europe/Rome by default

## Quick Start

### Using Docker

```bash
docker run -d \
  --name asterisk \
  -p 5038:5038 \
  -p 8088:8088 \
  -p 10000-20000:10000-20000/udp \
  -v /path/to/your/config:/etc/asterisk \
  agentvoiceresponse/avr-asterisk:latest
```

### Using Docker Compose

```yaml
version: '3.8'

services:
  asterisk:
    image: agentvoiceresponse/avr-asterisk:latest
    container_name: asterisk
    ports:
      - "5038:5038"  # Manager API
      - "8088:8088"  # HTTP API
      - "10000-20000:10000-20000/udp"  # RTP ports
    volumes:
      - ./config:/etc/asterisk
    restart: unless-stopped
```

## Configuration

The container uses the following default configuration files:
- `extensions.conf`
- `pjsip.conf`
- `manager.conf`
- `queues.conf`
- `ari.conf`

You can override these configurations by mounting your own configuration files to `/etc/asterisk/` in the container.

### Default Ports

- 5038: Asterisk Manager Interface (AMI)
- 8088: HTTP API
- 10000-20000: RTP ports for media streaming

## Environment Variables

- `TZ`: Timezone (default: Europe/Rome)

## Example Configuration Files

### pjsip.conf
```ini
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060

[6001]
type=endpoint
context=from-internal
disallow=all
allow=ulaw
allow=alaw
auth=6001
aors=6001

[6001]
type=auth
auth_type=userpass
password=your_password
username=6001

[6001]
type=aors
max_contacts=1
```

### extensions.conf
```ini
[from-internal]
exten => 6001,1,Answer()
exten => 6001,n,Echo()
exten => 6001,n,Hangup()
```

## Building from Source

If you want to build the image locally:

```bash
git clone https://github.com/your-repo/avr-asterisk.git
cd avr-asterisk
docker build -t agentvoiceresponse/avr-asterisk:latest .
```