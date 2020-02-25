#!/bin/bash


if [ "$1" == "shut" -o "$1" == "start" ]
then
        echo "Running PCF $1 Process..."
else
        echo "Only shut or start are valid args!"
        exit 1
fi


# These must be explicitly stopped due to nfs_mounter blocking as of 1.6.17
# declare -a bootOrder=(
# cloud_controller
# clock_global
# cloud_controller_worker
# )


if [ $1 == "shut" ]; then
        bosh deployments --json | jq ".Tables[0].Rows[].name" -r | while read deployment 
        do 
                echo $deployment: Stopping
                bosh stop -d $deployment --hard --skip-drain --non-interactive
        done
elif [ $1 == "start" ]; then
        bosh deployments --json | jq ".Tables[0].Rows[].name" -r | while read deployment 
        do 
                echo $deployment: Starting
                bosh -d $deployment  start  --non-interactive
        done
        bosh update-resurrection on
fi
