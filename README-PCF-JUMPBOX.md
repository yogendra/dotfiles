# PCF Tools

This gist has scripts to quickly setup a jumpbox.

- Downloads tools (cf, om, bbl, etc)
- Add direnv support
- Add PCF extensions
- Setup SSH keys for login from my devices
- **Adds my SSH public keys to `authorized_keys`**
- Downloads tile/stemcell packages from pivnet
- Build a jumpbox container image

## Update assets version/urls

- Update `scripts/generate-asset.sh`
- Run `scripts/generate-versions.sh > config/assets.json`
- Commit changes and push repo
- Turn on debugging by setting `_DEBUG` environment variable

## Build Docker Image

1. Create a file named `secrets.sh` in the project directory, with following content:

   ```bash
   export PIVNET_LEGACY_TOKEN=<CHANGE_ME>
   export GITHUB_TOKEN="<CHANGE_ME>"
   export GITHUB_REPO="<CHANGE_ME>"
   export TIMEZONE=<CHANGE_ME>
   ```

   - Replace `<CHANGE_ME>` with proper values.
   - `PIVNET_LEGACY_TOKEN` is token form [Pivnet Profile Page][pivnet-profile]. This is **required**
   - `GITHUB_TOKEB` is used for accessin github. This is useful if you hit API access limits.
   - `GITHUB_REPO` is the repository on github tha you want to use for init scripts
   - `TIMEZONE` is the timezone you want to set in the destination image

   **NOTE**: `GITHUB_OPTIONS` is optional and should be used if you run into API limit restrictions.

1. Create a docker network

   ```bash
   docker network create buildnet
   ```

1. Run a webserver to host secrets

   ```bash
   docker run --name secrets-server --rm --volume /home/docker-user:/usr/share/nginx/html:ro --network buildnet -d nginx
   ```

1. Copy `secrets.sh` to `secrets-server` container at `/usr/share/nginx/html`

   ```bash
   docker cp secrets.sh secrets-server:/usr/share/nginx/html/secrets.sh
   ```

1. (**Optional**) test server by running another container as follows

   ```bash
   docker run --name secrets-server-consumer --rm --network buildnet -t busybox wget -qO- http://secrets-server/secrets.sh
   ```

1. Run the build with following command

   ```bash
   docker build --no-cache --network buildnet --tag yogendra/pcf-jumpbox:latest -f yogendra_pcf-jumpbox.Dockerfile .
   ```

1. Test your container

   ```bash
   docker run --rm -it yogendra/pcf-jumpbox:latest -- ls -l bin/

   ```

1. Stop secrets webserver

   ```bash
   docker stop secrets-server
   ```

1. Remove `buildnet`

   ```bash
    docker network rm  buildnet
   ```

[pivnet-profile]: https://network.pivotal.io/users/dashboard/edit-profile
