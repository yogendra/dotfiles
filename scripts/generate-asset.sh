#!/usr/bin/env bash

JSON="{"
function _log {
    echo $@ >&2
}
function _debug {
    [[ -n $_DEBUG ]] && echo $@ >&2
}
function add_asset {
    product=$1
    source=$2
    version=$3
    url=$4
    
    if [[ $JSON != "{" ]]; then
        JSON="${JSON},"
    fi
    pjson="{ \"version\": \"$version\", \"source\": \"$source\" "

    if [[ -n $url ]]; then
        pjson="$pjson, \"url\": \"$url\""
    fi
    pjson="${pjson} }"

    JSON="$JSON
    \"$product\": $pjson"
    _log prepared $source::$product@$version::$url
}

function pivnet_asset {
    product=$1
    version=$2
    if [[ -z $version ]]; then
        version="$(pivnet releases -p $product --format json |jq -r '[.[] | select(.release_type != "Release Candidate")][0].version' | sed 's/^v//')"
    fi
    if [[ -z $version ]]; then
        version="$(pivnet releases -p $product --format json |jq -r '.[0].version' | sed 's/^v//')"
    fi
    add_asset "$product" "pivnet" "$version"
}

function _wget {
    _debug "_wget: $*"
    [[ -n $_DEBUG ]] && wget $*
    [[ -z $_DEBUG ]] && wget -q $*
}
function github_api {
    if [[ -z $GITHUB_TOKEN ]]; then
        _debug "github_api: no token"
        _wget -O- https://api.github.com$@
    else
        _debug "github_api: got token"        
        _wget  --header "'authorization: Bearer $GITHUB_TOKEN'" -O- https://api.github.com$@
    fi
    sleep 1
}
function github_version { 
    repo=$1
    version=$2
    if [[ -z $version ]]; then
        _debug "$repo: No version given checking latest"
        version=$(github_api /repos/$repo/releases/latest  | jq -r '.tag_name')
        
    fi
    _debug "$repo: [$version]"

    if [[ -z $version  ||  $version == "null" ]]; then
        _debug "$repo: No version determined checking prerelease"
        version="$(github_api /repos/$repo/releases  | jq -r '.[0].tag_name')"
    fi
    _debug "$repo: $version"
    echo $version
}
function github_asset {
    product=$1
    repo=$2
    exp="${3:-linux}"
    version=$4
    version=$(github_version "$repo" "$version")
    
    jq_exp=".assets[] | select(.name|test(\"$exp\"))|.browser_download_url"
    asset_url=$(github_api  /repos/${repo}/releases/tags/${version} | jq -r "${jq_exp}")

    _debug "product:$product repo:$repo exp:$exp version:$version jq_exp:$jq_exp asset_url:$asset_url"

    add_asset "$product" "github" "$version" "$asset_url" 
}


version="0.11.14"
add_asset "terraform" "custom" "$version" "https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip"

version=$(github_version cloudfoundry/cli)
add_asset "cf" "custom" "$version" "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=${version#v}&source=github-rel"

version=$(_wget -O- https://storage.googleapis.com/kubernetes-release/release/stable.txt)
add_asset "kubectl" "custom" "$version" "https://storage.googleapis.com/kubernetes-release/release/$version/bin/linux/amd64/kubectl"


pivnet_asset "pivotal-function-service"
pivnet_asset "pivotal-container-service"
pivnet_asset "p-scheduler"
pivnet_asset "pcf-app-autoscaler" 
pivnet_asset "p-event-alerts"
pivnet_asset "container-services-manager"
pivnet_asset "build-service"

github_asset bosh cloudfoundry/bosh-cli linux-amd64
github_asset bbl cloudfoundry/bosh-bootloader linux_x86-64
github_asset fly concourse/concourse fly.\*linux-amd64.tgz\$
github_asset om pivotal-cf/om om-linux.\*tar.gz\$
github_asset bbr cloudfoundry-incubator/bosh-backup-and-restore bbr-.\*-linux-amd64\$
github_asset credhub cloudfoundry-incubator/credhub-cli credhub-linux-.\*.tgz\$
github_asset pack buildpacks/pack pack-v.\*-linux.tgz\$
github_asset texplate pivotal-cf/texplate linux_amd64
github_asset docker-machine docker/machine Linux-x86_64
github_asset docker-compose docker/compose Linux-x86_64\$
github_asset riff projectriff/cli linux-amd64 
github_asset uaa cloudfoundry-incubator/uaa-cli linux-amd64
github_asset pivnet pivotal-cf/pivnet-cli linux-amd64
github_asset riff projectriff/cli  linux-amd64 
github_asset bat sharkdp/bat x86_64-unknown-linux-gnu 
github_asset direnv direnv/direnv linux-amd64

JSON="$JSON
}"


echo "$JSON" | jq -S



