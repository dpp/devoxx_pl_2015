import subprocess
from subprocess import call
from random import randint
import time
import os

host = os.getenv('HOST_TO_POST', 'localhost:8000')

me = os.getenv('ME', 'rogue')

# Wait for network to come up

while True:
    p = subprocess.Popen(['ifconfig'], stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    out, err = p.communicate()
    if "ethwe" in out: break
    if "en0" in out: break
    time.sleep(1)
    print "Waiting for network to come up"

# Get a list of the top web sites
f = open('top_1000.txt', 'r')

top = []

for i in f:
    top.append(i.strip()),

f.close

# Keep loading a random site
while True:
    toLoad = top[randint(0, len(top) - 1)]
    print "Trying ", toLoad
    call(["wget", "-q", "--timeout=5", "-O", "dog.got", toLoad])
    # And report it
    call(["wget", "-q", "-O", "dog.got",
          "http://" + host + "/index.html?site=" + toLoad + "&me=" + me])
    call(["rm", "dog.got"])
