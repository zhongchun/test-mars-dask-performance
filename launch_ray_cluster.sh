#! /usr/bin/env bash

usage() {
    msg=$1
    echo -e "Argument error:\n  $msg\nUsage:\n  sh $0 -t {head|worker|stop} -a {server_address} -w {password}"
}

while getopts t:a:w: flag
do
    case "${flag}" in
        t) service_name=${OPTARG};;
        a) server_address=${OPTARG};;
        a) password=${OPTARG};;
    esac
done

if [[ $service_name != @(""|"head"|"worker"|"stop") ]]; then
    usage "-t value must be in [head, worker, stop] or null"
    exit -1
fi

BASEDIR=$(cd $(dirname "$0") && pwd)
source $BASEDIR/utils/common.sh

service_name=$(set_default $service_name "worker")
if [[ $service_name == "worker" && ! $server_address ]]; then
    usage "default -t is worker, please assign -a when -t worker"
    exit -1
fi

password=$(set_default $password "5241590000000000")

log "service_name: $service_name"
log "server_address: $server_address"
log "password: $password"

if [[ $service_name == "head" ]]; then
    port="6379"
    dashboard_host="0.0.0.0"
    log "Launching Ray $service_name with port $port, dashboard host $dashboard_host ... "
    ray start --head --port=$port --dashboard-host=$dashboard_host
fi


if [[ $service_name == "worker" ]]; then
    log "Launching Ray worker to $server_address ..."
    ray start --address=$server_address --redis-password=$password
fi

if [[ $service_name == "stop" ]]; then
    ray stop
    log "Ray services exited"
fi
