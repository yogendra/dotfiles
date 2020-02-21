#!/usr/bin/env bash
JSON="{"

function add_version {
    PROD=$1
    VERSION=$2
    JSON_ELEMENT="\"${PROD}\": \"${VERSION}\""
    if [[ $JSON != "{" ]]; then
        JSON="${JSON},"
    fi
    JSON="$JSON
    ${JSON_ELEMENT}"
}
function pivnet_version {
    product=$1
    version="$(pivnet releases -p $product --format json | jq -r '. |= sort_by("release_date") | .[0].version' | sed 's/^v//')"
    add_version "$product" "$version"
}

function github_version {
    product=$1
    repo=$2
    version="$(wget ${GITHUB_OPTIONS} -qO- https://api.github.com/repos/$repo/releases  | jq -r '. | map(select (.prerelease == false))| .[0].tag_name' | sed 's/^v//')"
    [[ $version == "null" ]] && \
        version="$(wget ${GITHUB_OPTIONS} -qO- https://api.github.com/repos/$repo/releases  | jq -r '.[0].tag_name' | sed 's/^v//')"
    add_version "$product" "$version"
}


add_version "terraform" "0.11.14"

pivnet_version "pivotal-function-service"
pivnet_version "pivotal-container-service"
pivnet_version "p-scheduler"
pivnet_version "pcf-app-autoscaler" 
pivnet_version "p-event-alerts"
pivnet_version "container-services-manager"
pivnet_version "build-service"

github_version "riff" "projectriff/cli"
github_version "cf" "cloudfoundry/cli"
github_version "docker" "docker/docker-ce"
github_version "buildpack" "buildpacks/pack"
github_version "duffle" "cnabio/duffle"

JSON="$JSON
}"
echo "$JSON" | jq -S
