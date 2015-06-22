#!/bin/bash

echo "Starting port scan"

nmap -sS "$( ifconfig | grep "inet addr" | egrep -o -e '10\.[0-9]+\.[0-9]+\.')0/22"
