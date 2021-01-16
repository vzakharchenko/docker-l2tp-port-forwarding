docker build -t l2tp-port-forwarding .
docker tag  l2tp-port-forwarding vassio/l2tp-port-forwarding:1.0.1_arm64
docker push vassio/l2tp-port-forwarding:1.0.1_arm64

docker tag  l2tp-port-forwarding vassio/l2tp-port-forwarding:latest_arm64
docker push vassio/l2tp-port-forwarding:latest_arm64
