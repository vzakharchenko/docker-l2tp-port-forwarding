docker build -t l2tp-port-forwarding .
docker tag  l2tp-port-forwarding vassio/l2tp-port-forwarding:1.0.1
docker push vassio/l2tp-port-forwarding:1.0.1

docker tag  l2tp-port-forwarding vassio/l2tp-port-forwarding:latest
docker push vassio/l2tp-port-forwarding:latest
