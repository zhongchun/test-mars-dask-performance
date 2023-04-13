#! /usr/bin/env bash

if [[ $# < 3 ]]; then
    echo "usage: sh $0 -a {address} -w {redis_password} -r {round} -s {size}"
    exit 0
fi

BASEDIR=$(cd $(dirname "$0") && pwd)
echo "BASEDIR: $BASEDIR"

source $BASEDIR/utils/common.sh

while getopts a:w:r:s: flag
do
    case "${flag}" in
        a) address=${OPTARG};;
        w) redis_password=${OPTARG};;
        r) round=${OPTARG};;
        s) size=${OPTARG};;
    esac
done

address=$(set_default $address "127.0.0.1:9008")
log "address: $address"
redis_password=$(set_default $redis_password "5241590000000000")
log "redis_password: $redis_password"
round=$(set_default $round 3)
log "round: $round"
size=$(set_default $size 1000)
log "size: $size"

command="python ${BASEDIR}/e2e/test_performence_mars_cluster_on_ray.py $address $redis_password $size"

run_loop $round "$command"
