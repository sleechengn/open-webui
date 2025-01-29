Service Port: http://IP:80

Filebrowser: http://IP/filebrowser

TTY: http://IP/ttyd

```
networks:
  lan13:
    name: lan13
    driver: macvlan
    driver_opts:
      parent: enp6s19
    ipam:
      config:
        - subnet: "192.168.13.0/24"
          gateway: "192.168.13.1"
services:
  ollama:
    container_name: "ollama"
    hostname: "ollama"
    image: "sleechengn/ollama:latest"
    restart: unless-stopped
    command: ["serve"]
    environment:
      - TZ=Asia/Shanghai
      - NVIDIA_DRIVER_CAPABILITIES=all
      - NVIDIA_VISIBLE_DEVICES=all
      - OLLAMA_DEBUG=1
      - OLLAMA_HOST=0.0.0.0:11434
      - OLLAMA_NUM_PARALLEL=1
      - OLLAMA_MAX_QUEUE=1
      - OLLAMA_MAX_LOADED_MODELS=1
    runtime: nvidia
    volumes:
      - "ollama-model:/root/.ollama"
      - "/mnt/rfs:/mnt/rfs"
    networks:
      lan13:
        ipv4_address: 192.168.13.78
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
  open-webui:
    container_name: open-webui
    hostname: open-webui
    image: sleechengn/open-webui:latest
    restart: unless-stopped
    environment:
      - OLLAMA_BASE_URL=http://192.168.13.78:11434
      - HF_ENDPOINT=https://hf-mirror.com
      #- RESET_CONFIG_ON_START=true
      - TZ=Asia/Shanghai
    volumes:
      - "open-webui:/app/backend/data"
      - "openweb-ui-doc:/data/docs"
    networks:
      lan13:
        ipv4_address: 192.168.13.79
volumes:
  ollama-model:
    name: ollama-model
    driver: local
    driver_opts:
      o: bind
      type: none
      device: /mnt/nvme/ollama/root/.ollama
  open-webui:
    name: open-webui
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ./openwebui/app/backend/data
  openweb-ui-doc:
    name: openweb-ui-doc
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ./openwebui/data/docs
```
