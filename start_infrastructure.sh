#!/bin/bash

# Bring up weave

weave launch

# bring up infrastructure


if [ -z "$(docker ps --filter="name=serve" | grep serve)" ]; then
    run_serve='docker run -d -p 80:80 --restart="always" --name=serve doall python /serve.py'
else
    run_serve='true'
fi

if [ -z "$(docker ps --filter="name=squid" | grep squid)" ]; then
    run_squid='docker run --name="squid" --restart="always" --link serve:serve -d sameersbn/squid:latest'
else
    run_squid='true'
fi

eval "$run_serve" && eval "$run_squid"
