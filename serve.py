import SimpleHTTPServer
import SocketServer
from os import chdir, geteuid
from subprocess import call

call(["mkdir", "-p", "here"])
call(["touch", "here/index.html"])
chdir("here")

PORT = 80

if geteuid() != 0:
    PORT = 8000

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
httpd = SocketServer.TCPServer(("", PORT), Handler)
httpd.serve_forever()
