#!/usr/bin/env bash
# From an installation project folder (configured to connect to pcf/opsmanager), run following to upload tiles 
# wget -qO- "https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec/raw/om-install.sh"  | bash


function pipe(){
    product=$1
    version=$2
    fileglob=$3
    ufileglob=$(echo $fileglob | sed 's/\\//')

    echo om download-product --pivnet-api-token $PIVNET_TOKEN  --product $product --product-version $version --pivnet-file-glob $fileglob
    echo om -k upload-product -p $ufileglob
}
pipe apm '1.6.0'  "apm\*.pivotal"
pipe credhub-service-broker '1.2.0'  "credhub-service-broker\*.pivotal"
pipe p-cloud-cache '1.6.1'  "p-cloud-cache\*.pivotal"
pipe p-dataflow '1.3.1'  "p-dataflow\*.pivotal"
pipe p-event-alerts '1.2.6'  "p-event-alerts\*.pivotal"
pipe p-healthwatch '1.4.4'  "p-healthwatch\*.pivotal"
pipe p-rabbitmq '1.15.3'  "p-rabbitmq\*.pivotal"
pipe p-redis '2.0.0'  "p-redis-\*.pivotal"
pipe p-scheduler '1.1.4'  "p-scheduler\*.pivotal"
pipe p-spring-cloud-services '2.0.5'  "p-spring-cloud-services-\*.pivotal"
pipe pivotal-mysql '2.5.3'  "pivotal-mysql\*.pivotal"
pipe pivotal_single_sign-on_service 1.7.2  "Pivotal_Single_Sign-On_Service\*.pivotal"