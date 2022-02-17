#!/usr/bin/env bash


function setup_disk(){
    DEVICE=$1
    DEVICE_FS=$2
    MOUNT=$3
    lsblk
    if [[ "data" == $(sudo file -bs $DEVICE) ]]; then
        sudo mkfs -t $DIVECE_FS  $DEVICE
        sudo file -s $DEVICE
    fi
    sudo mkdir $MOUNT
    sudo mount $DEVICE $MOUNT
    sudo chmod 777 $MOUNT
    echo "UUID=$(lsblk -o UUID $DEVICE  -n) $MOUNT $DIVECE_FS defaults,noatime,nofail  0  2" | sudo tee -a /etc/fstab
}

DEVICE=${1:-/dev/nvme1n1}; shift
FS=${1:-xfs}
MOUNT=${1;-/mnt/d0}
echo setup_disk $FS $DEVICE $MOUNT
