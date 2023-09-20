## Setup
Install:
- docker
- minikube
- kubectl
- helm

```bash
# Set minikube to use docker driver
minikube config set driver docker

minikube start start --cpus 4 --memory 8192
```


## Deploy the stack 
A simple setup script [build.sh](./build.sh) can be used to deploy the stack. 

In a new terminal, add port forwarding:
```bash
kubectl port-forward service/{{ elastic client service }} 9200
kubectl port-forward service/{{ kibana service }} 5601
```
To bind it to all interfaces (accessible from other hosts) add the following flag `--address 0.0.0.0`


## Send messages
```bash
# Get the elastic password
PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo)
# POST a message to the quickstart-es-ingest-data node
curl -u "elastic:$PASSWORD" -k -XPOST https://localhost:9200/test_index/_doc -H "Content-Type: application/json" -d "{ \"test_field\" : \"test value\" }"
```

## View messages on Kibana
Visit https://localhost:5601/app/dashboards using the credentials from [Send Message](#send-messages)