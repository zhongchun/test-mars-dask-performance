#! /usr/bin/env bash

time_stamp() {
    date +"%s"
}

log() {
    msg="${1:-''}"
    echo "[`date +"%Y-%m-%d %T,%N"`] $msg"
}

set_default() {
    value=$1
    default_value=$2
    if [ -z $value ]; then
        value=$default_value
    fi
    echo "$value"
}

# Note: argument command should be quoted, like
# command="python ${BASEDIR}/rpc/mars_socket_call.py $size"
# run_loop $round "$command" $interval
run_loop() {
    round="${1:-3}"
    command="${2:-''}"
    interval="${3:-3}"
    log "round: ${round}"
    log "command: ${command}"
    log "interval: ${interval}"

    for ((i=1;i<=$round;i++))
    do
        log "round i: $i"
        log "***********************************************************"
        log "running: $command"
        ``$command``
        sleep $interval
    done
    log "==========================================================="
}

