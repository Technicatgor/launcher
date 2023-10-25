#!/bin/ash
docker run --init --restart=always --name prometheus-pve-exporter -d -p 9221:9221 -v ./pve.yml:/etc/pve.yml prompve/prometheus-pve-exporter
