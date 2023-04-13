#! /usr/bin/env bash

usage() {
    echo -e "Argument error, usage:\n  sh $0 -t {scheduler|worker|stop} -a {server_address} -w {nworkers}"
}

while getopts t:a:w: flag
do
    case "${flag}" in
        t) service_name=${OPTARG};;
        a) server_address=${OPTARG};;
        w) nworkers=${OPTARG};;
    esac
done

if [[ ! $service_name ]]; then
    usage
    exit -1
fi

if [[ $service_name != @("scheduler"|"worker"|"stop") ]]; then
    usage
    exit -1
fi

BASEDIR=$(cd $(dirname "$0") && pwd)
echo "BASEDIR: $BASEDIR"

source $BASEDIR/utils/common.sh

default_host=$(hostname -i)
default_port="8786"
default_address="${default_host}:${default_port}"
service_name=$(set_default $service_name "scheduler")
server_address=$(set_default $server_address "$default_address")
nworkers=$(set_default $nworkers 8)

log_dir="${BASEDIR}/logs/"
timestamp=$(time_stamp)
nthreads=1

log "service_name: $service_name"
log "server_address: $server_address"
log "log_dir: $log_dir"
log "timestamp: $timestamp"

if [[ ! -d $log_dir ]]; then
    mkdir $log_dir
    log "Directory $log_dir created."
fi

if [[ $service_name == "scheduler" ]]; then
    log "Launching $service_name with address $server_address ... "
    log_file="$log_dir/dask_scheduler_${timestamp}.log"
    dask-scheduler --host $server_address > $log_file 2>&1 &
    sleep 3
    log "Dask $service_name launched on $server_address and log in $log_file"
fi


if [[ $service_name == "worker" ]]; then
    log "launching dask workers with $nworkers nworkers, $nthreads nthreads to $server_address ..."
    log_file="$log_dir/dask_worker_${timestamp}.log"
    dask-worker $server_address --nworkers $nworkers --nthreads $nthreads > $log_file 2>&1 &
    sleep 3
    log "Dask workers launched connected to $server_address and log in $log_file"
fi

if [[ $service_name == "stop" ]]; then
    pkill -f python -9
    sleep 3
    log "Dask services exited"
fi
