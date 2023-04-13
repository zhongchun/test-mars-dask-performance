#! /usr/bin/env bash

if [[ $# < 2 ]]; then
    echo "usage: sh $0 -a {address} -w {password} -r {round} -s {size}"
    exit 0
fi

BASEDIR=$(cd $(dirname "$0") && pwd)
echo "BASEDIR: $BASEDIR"

source $BASEDIR/utils/common.sh

while getopts a:w:r:s: flag
do
    case "${flag}" in
        a) address=${OPTARG};;
        w) password=${OPTARG};;
        r) round=${OPTARG};;
        s) size=${OPTARG};;
    esac
done

address=$(set_default $address "auto")
log "address: $address"
password=$(set_default $password "5241590000000000")
log "password: $password"
round=$(set_default $round 1)
log "round: $round"
size=$(set_default $size 1000)
log "size: $size"

# mars on ray
sh cluster_mars_on_ray_e2e_pipeline.sh -a $address -w $password -r $round -s $size
sleep 3
# mars on ray dag
sh cluster_mars_on_ray_dag_e2e_pipeline.sh -a $address -w $password -r $round -s $size
