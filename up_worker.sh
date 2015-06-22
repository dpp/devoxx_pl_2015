#!/bin/bash

if [[ $1 = "" ]]; then
    echo "Require second parameter... the last two parts of the IPV4 address. e.g., 4.2"
    exit 9
fi

whole=$(echo "$1" | egrep -o '^[0-9]+\.[0-9]+$')

if [[ ! $whole = $1 ]]; then
   echo "Bad input $1"
fi

first=$(echo "$1" | egrep -o '^[0-9]+')

last=$(echo "$1" | egrep -o '[0-9]+$')

has_squid=$(weave ps squid | egrep -o "10.4.${first}.240/24")

if [[ $has_squid = "" ]]; then
    echo "Attaching squid squid"
    weave attach "10.4.${first}.240/24" squid
fi

container=$(docker run -e http_proxy="http://10.4.${first}.240:3128" \
       -e https_proxy="https://10.4.${first}.240:3128" \
       -e HOST_TO_POST="serve" \
       -e ME="$1" \
       -d \
       -m 100M --memory-swap 100M \
       --net=none doall:latest python /load.py)

weave attach "10.4.$1/24" "$container"
