# Security with Docker and Weave

The presentation at Devoxx PL on Securing PaaS with
Docker and Weave and supporting files.

## Before you start

Make sure [Docker](https://docs.docker.com/installation/mac/) and
[Weave](https://github.com/weaveworks/weave#installation) are
installed.

These scripts assume that you can run Docker and Weave from user-space
not sudo space.

Test Docker:

```
sand:~ dpp$ docker ps
CONTAINER ID        IMAGE                    COMMAND                CREATED             STATUS                        PORTS                     NAMES
484bd16e3c82        sameersbn/squid:latest   "/start"               28 hours ago        Up 28 hours                   3128/tcp                  squid
```

Test Weave:

```
sand:~ dpp$ weave ps
weave:expose 5e:c8:c7:27:1e:49
```

## How to use sample code

Create the `doall` image by running the `./mk_doall.sh` script.

Start the infrastructure by running `./start_infrastructure.sh`.

This script starts the following if they are not already running:

* Weave
* The "service" process
* Squid proxy

Bring up a worker with `./up_worker.sh 4.2` which brings up a worker
on `10.4.4.2` and makes sure the squid proxy is at `10.4.4.240`.

You can see the worker doing work by tailing the `serve` logs:
`docker logs -f serve`:

```
sand:devoxx_pl_2015 dpp$ docker logs -f serve
172.17.0.22 - - [22/Jun/2015 09:54:44] "GET /index.html?site=virginmedia.com&me=4.2 HTTP/1.1" 200 -
172.17.0.22 - - [22/Jun/2015 09:54:45] "GET /index.html?site=zaycev.net&me=4.2 HTTP/1.1" 200 -
172.17.0.22 - - [22/Jun/2015 09:54:46] "GET /index.html?site=hurriyet.com.tr&me=4.2 HTTP/1.1" 200 -
```

Next, bring up another worker on another subnet: `./up_worker.sh 5.2`

Finally, bring up the port scanner: `./up_scan.sh 4.4` and run the port scanner:

```
root@3c57581cc657:/# ./port_scan.sh

Nmap scan report for 10.4.4.2
Host is up (0.000082s latency).
All 1000 scanned ports on 10.4.4.2 are closed
MAC Address: 0E:96:A4:C9:FF:BE (Unknown)

Nmap scan report for 10.4.4.240
Host is up (0.000088s latency).
Not shown: 999 closed ports
PORT     STATE SERVICE
3128/tcp open  squid-http
MAC Address: A6:F9:1D:5E:53:7B (Unknown)

Nmap scan report for 10.4.4.4
Host is up (0.000022s latency).
All 1000 scanned ports on 10.4.4.4 are closed

Nmap done: 256 IP addresses (3 hosts up) scanned in 121.05 seconds

```

Even though there's a host running at `10.4.5.2` and Squid running at `10.4.5.240`,
neither of those hosts is visible from the `10.4.4.0/24` subnet
