## Setup
Install:
- docker
- minikube
- kubectl

```bash
# Set minikube to use docker driver
minikube config set driver docker

minikube start start --cpus 4 --memory 8192
```


## Deploy the ECK 
```bash
kubectl create -f https://download.elastic.co/downloads/eck/2.8.0/crds.yaml

kubectl apply -f https://download.elastic.co/downloads/eck/2.8.0/operator.yaml
```
## Deploy Elasticsearch cluster

may need to increase vm.max_map_count
```bash
sudo sysctl -w vm.max_map_count=262144
```

```bash
kubectl apply -f elasticsearch.yaml
```
in a new terminal, add port forwarding:
```bash
# To bind it to all interfaces (accessible from other hosts):
kubectl port-forward --address 0.0.0.0 service/quickstart-es-client <exposed port>:9200
# To expose it internally (localhost):
kubectl port-forward service/quickstart-es-client <exposed port>:9200
```

## Deploy Kibana
```bash
kubectl apply -f kibana.yaml
```
in a new terminal, add port forwarding:
```bash
# To bind it to all interfaces (accessible from other hosts):
kubectl port-forward --address 0.0.0.0 service/kibana-kb-http <exposed port>:5601
# To expose it internally (localhost):
kubectl port-forward service/kibana-kb-http <exposed port>:5601
```

## Send messages
```bash
# Get the elastic password
PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo)
# POST a message to the quickstart-es-ingest-data node
curl -u "elastic:$PASSWORD" -k -XPOST https://localhost:9200/test_index/_doc -H "Content-Type: application/json" -d "{ \"test_field\" : \"test value\" }"
```

## View messages on Kibana
Visit https://localhost:5601/app/dashboards using the credentials from [Send Message](#send-messages)