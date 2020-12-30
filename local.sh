docker stop l2tp-port-forwarding
docker rm l2tp-port-forwarding

docker build -t l2tp-port-forwarding .
docker run --name=l2tp-port-forwarding -v /home/vzakharchenko/home/docker-l2tp-port-forwarding/examples/config.json:/opt/config.json --privileged l2tp-port-forwarding
