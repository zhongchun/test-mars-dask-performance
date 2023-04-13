#! /usr/bin/env bash

usage() {
    echo -e "Argument error, usage:\n  sh $0 -t {supervisor|worker|stop} -a {server_address}"
}

while getopts t:a: flag
do
    case "${flag}" in
        t) service_name=${OPTARG};;
        a) server_address=${OPTARG};;
    esac
done

if [[ ! $service_name ]]; then
    usage
    exit -1
fi

if [[ $service_name != @("supervisor"|"worker"|"stop") ]]; then
    usage
    exit -1
fi

BASEDIR=$(cd $(dirname "$0") && pwd)
echo "BASEDIR: $BASEDIR"

source $BASEDIR/utils/common.sh

default_host=$(hostname -i)
default_port="8001"
supervisor_port="9001"
web_port="9008"
supervisor_address="${default_host}:${supervisor_port}"
service_name=$(set_default $service_name "supervisor")
server_address=$(set_default $server_address "$supervisor_address")

log_dir="${BASEDIR}/logs/"
timestamp=$(time_stamp)
nworkers=8

log "service_name: $service_name"
log "server_address: $server_address"
log "log_dir: $log_dir"
log "timestamp: $timestamp"

if [[ ! -d $log_dir ]]; then
    mkdir $log_dir
    log "Directory $log_dir created."
fi

if [[ $service_name == "supervisor" ]]; then
    log "Launching Mars $service_name with server address $server_address, dashboard port $web_port"
    log_file="$log_dir/mars_standard_cluster_supervisor_${timestamp}.log"
    mars-supervisor -H $default_host -p $supervisor_port -w $web_port -s $server_address > $log_file 2>&1 &

    sleep 3
    log "Mars $service_name launched on $server_address and log in $log_file"
fi


if [[ $service_name == "worker" ]]; then
    log "launching Mars workers with $nworkers workers to $server_address ..."
    log_file="$log_dir/mars_standard_cluster_worker_${timestamp}.log"
    mars-worker -H $default_host -p $default_port -s $server_address --n-cpu $nworkers > $log_file 2>&1 &
    sleep 3
    log "Mars workers launched and connected to $server_address, log in $log_file"
fi

if [[ $service_name == "stop" ]]; then
    pkill -f python -9
    sleep 3
    log "Mars services exited"
fi
