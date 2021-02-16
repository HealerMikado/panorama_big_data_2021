import socket
import sys
import threading
from time import sleep
import requests
import sseclient
import json

all_connections = []
all_address = []

proxies = {
    "http": "http://pxcache-02.ensai.fr:3128",
    "https": "http://pxcache-02.ensai.fr:3128",
}


# Create a Socket ( connect two computers)
def create_socket():
    try:
        global host
        global port
        global s
        host = ""
        port = 10003
        s = socket.socket()

    except socket.error as msg:
        print("Socket creation error: " + str(msg))


# Binding the socket and listening for connections
def bind_socket():
    try:
        global host
        global port
        global s
        print("Binding the Port: " + str(port))

        s.bind((host, port))
        s.listen(5)

    except socket.error as msg:
        print("Socket Binding error" + str(msg) + "\n" + "Retrying...")
        bind_socket()


# Handling connection from multiple clients and saving to a list
# Closing previous connections when server.py file is restarted

def accepting_connections():
    for c in all_connections:
        c.close()

    del all_connections[:]
    del all_address[:]

    while True:
        try:
            conn, address = s.accept()
            all_connections.append(conn)
            all_address.append(address)

            print("Connection has been established :" + address[0])

        except:
            print("Error accepting connections")


def connection_process():
    create_socket()
    bind_socket()
    accepting_connections()


def with_requests(url):
    """Get a streaming response for the given event feed using requests."""
    return requests.get(url, proxies=proxies, stream=True)


def broadcast_message():
    url = 'https://stream.wikimedia.org/v2/stream/recentchange'
    while True :
        try :
            while not all_connections:
                pass
            with requests.get(url, stream=True) as stream:
                print("new connexion to Stream")
                client = sseclient.SSEClient(stream)

                # On attend qu'il y ai au moins une connexion pour faire quelque chose
                while all_connections:
                    for event in client.events():
                        if event.event == 'message':
                            # Récupération d'une info
                            change = json.loads(event.data)
                            change.pop('meta', None)
                            change.pop('revision', None)
                            change.pop('length', None)
                            change = json.dumps(change, indent=None) + "\n"

                            # Broadcasting
                            for i, conn in enumerate(all_connections):
                                try:
                                    conn.send(change.encode("utf-8"))
                                except socket.error:
                                    print("Supression connection %s " % conn)
                                    all_connections.pop(i)
                            # S'il n'y a plus de connexion arrête d'écouter l eflux
                            if not all_connections:
                                break
                    sleep(0.1)
        except :
            print("Une errer s'est produite")



if __name__ == '__main__':
    # gère les connexions
    connexion_thread = threading.Thread(target=connection_process)
    # envoie les données
    broadcast_thread = threading.Thread(target=broadcast_message)

    # On lance les threads
    connexion_thread.start()
    broadcast_thread.start()

    # On attend qu'ils terminent tous les deux
    connexion_thread.join()
    broadcast_thread.join()
