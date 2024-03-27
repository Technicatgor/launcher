## Repository
repo: https://github.com/wg-easy/wg-easy

## Prerequisite
cp .env.example .env
```
WG_HOST=your-wan-ip
PASSWORD=password # for web-ui login
```
create a docker network called wg-network
```
docker network create wg-network
```
docker-compose.yml
```
version: "3.8"
services:
  wg-easy:
    environment:
      WG_HOST: ${WG_HOST}
      PASSWORD: ${PASSWORD}
    image: weejewel/wg-easy
    container_name: wireguard
    volumes:
      - ./:/etc/wireguard/
    ports:
      - "51820:51820/udp"
      - "51821:51821/tcp"
    networks:
      wg-network:
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
networks:
  wg-network:
    external: true
```
log into web-ui `http://localhost:51821`

set the PAT in your Firewall

