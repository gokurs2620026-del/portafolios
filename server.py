#!/usr/bin/env python3
from http.server import HTTPServer, SimpleHTTPRequestHandler
import os

class MyHTTPRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()

os.chdir(r'c:\Users\USUARIO\Downloads\Trabajo')

server_address = ('0.0.0.0', 8000)
httpd = HTTPServer(server_address, MyHTTPRequestHandler)

print("=" * 50)
print("🚀 Servidor activo en:")
print("=" * 50)
print("http://localhost:8000")
print("http://127.0.0.1:8000")
print("\n📡 Accesible desde otros dispositivos:")
print("http://<TU_IP_LOCAL>:8000")
print("\nPara encontrar tu IP, ejecuta: ipconfig")
print("=" * 50)
print("Presiona Ctrl+C para detener el servidor")
print("=" * 50)

try:
    httpd.serve_forever()
except KeyboardInterrupt:
    print("\n✓ Servidor detenido")
