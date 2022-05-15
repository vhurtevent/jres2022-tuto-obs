import http.server
import requests
import time
import prometheus_client as prom

JRES_HELLO_LATENCY_HISTO = prom.Histogram('jres_hello_latency_seconds', 'Durée de réponse au Hello JRES', buckets=['0','0.1','0.2','0.4','0.6','0.8','1','2.5','5'])
JRES_HELLO_COUNTER = prom.Counter('jres_hello_total', 'Compteur du nombre d\'affichage d\'Hello JRES ', ["route"])
#JRES_WEBSITES_RESPONSE_TIME_GAUGE = prom.Gauge('jres_websites_response_time', 'Jauge du temps de réponse des sites Web JRES en milliseconde', ["site"])
JRES_WEBSITES_RESPONSE_TIME_HISTO = prom.Histogram('jres_websites_response_time', 'Jauge du temps de réponse des sites Web JRES en seconde', ["site"], buckets=['0','0.01','0.02','0.04','0.06','0.08','0.1','0.125','0.15','0.2','0.5','1'])

URL_LIST = ["https://www.jres.org", "https://archives.jres.org", "https://conf-ng.jres.org"] 

def get_response(url: str) -> dict:
    response = requests.get(url)
    response_time = response.elapsed.total_seconds()
    return response_time

class MyHandler(http.server.BaseHTTPRequestHandler):
    @JRES_HELLO_LATENCY_HISTO.time()
    def do_GET(self):
        for url_name in URL_LIST:
            response_time = get_response(url_name)
            # JRES_WEBSITES_RESPONSE_TIME_GAUGE.labels(site=url_name).set(response_time)
            JRES_WEBSITES_RESPONSE_TIME_HISTO.labels(site=url_name).observe(response_time)
        JRES_HELLO_COUNTER.labels(route=self.path).inc()
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Hello JRES !")

if __name__ == "__main__":
  print("Prometheus metrics accessibles sur le port 9090 sur /metrics")
  print("Application principale accessible sur le port 8080")
  prom.start_http_server(9090)
  server = http.server.HTTPServer(('', 8080), MyHandler)
  server.serve_forever()
