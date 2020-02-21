# PCF Tools

- Includes jumpbox initialization scripts
- Direnv config
- Tmux config
- Vim setup

# Quickstart

- On VM

```bash
read -s -p "Enter Pivnet Legacy token (Not ending in '-r'): " OM_PIVNET_TOKEN
wget -qO- "https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec/raw/jumpbox-init.sh?nocache"  | bash
```

- Using docker

```bash
# Run container
docker run --name pcf-jumpbox --hostname pcf-jumpbox -v $HOME/workspace:/home/pcf/workspace yogendra/pcf-jumpbox -d

# Connect to container
docker exec -it pcf-jumpbox bash

```
