#! /usr/bin/env bash

if [[ $# < 2 ]]; then
    echo "usage: sh $0 -a {address} -r {round} -s {size}"
    exit 0
fi

BASEDIR=$(cd $(dirname "$0") && pwd)
echo "BASEDIR: $BASEDIR"

source $BASEDIR/utils/common.sh

while getopts a:r:s: flag
do
    case "${flag}" in
        a) address=${OPTARG};;
        r) round=${OPTARG};;
        s) size=${OPTARG};;
    esac
done

address=$(set_default $address "127.0.0.1:8786")
log "address: $address"
round=$(set_default $round 3)
log "round: $round"
size=$(set_default $size 1000)
log "size: $size"

command="python ${BASEDIR}/e2e/test_performence_dask_cluster.py $address $size"

run_loop $round "$command"
