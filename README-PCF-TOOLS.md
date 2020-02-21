# PCF Tools

This gist has scripts to quickly setup a jumpbox.

- Downloads tools (cf, om, bbl, etc)
- Add direnv support
- Add PCF extensions
- Setup SSH keys for login from my devices
- **Adds my SSH public keys to `authorized_keys`**
- Downloads tile/stemcell packages from pivnet
- Build a jumpbox container image

## Update versions

- Open `generate-version.sh`
- Update line with calls to `add_version`
- Run `./generate-versions.sh > versions.json`
- Commit changes and push repo

## Build Docker Image

You will require:

1. Docker on you machine

1. Create a file named `secrets.txt` with content like following:

   ```bash filename=secrets.txt
   export GIST_URL="https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec"
   export OM_PIVNET_TOKEN=ASDSAD_DASDSAD
   export GITHUB_OPTIONS="--http-user github_user --http-password asjhdkjsahd32423jkhkj4i32h432h4jkh2 --auth-no-challenge"

   ```

   - `GITHUB_OPTIONS` is optional and should be used if you run into API limit restrictions.

1. You may need to copy secrets file to docker host in case you are running a VM

   - Docker machine (Example: Machine name `myci`, host directory `/home/docker-user`)

     ```bash
     docker-machine scp secrets.txt myci:/home/docker-user/secrets.txt
     ```

1. Create a docker network

   ```bash
   docker network create buildnet
   ```

1. Run a webserver to host secrets and. (Example: Host directory `/home/docker-user`)

   ```bash
   docker run --name secrets-server --rm --volume /home/docker-user:/usr/share/nginx/html:ro --network buildnet -d nginx
   ```

   (**Optional**) test server by running another container as follows

   ```bash
   docker run --name secrets-server-consumer --rm --network buildnet -t busybox wget -qO- http://secrets-server/secrets.txt
   ```

1. Run the build with following command

   ```bash
   docker build --no-cache --network buildnet --tag yogendra/pcf-jumpbox:latest .
   ```

1. Stop secrets webserver

   ```bash
   docker stop secrets-server
   ```

1. Remove file from Docker host

   ```bash
   docker-machine ssh myci rm /home/docker-user/secrets.txt
   ```
