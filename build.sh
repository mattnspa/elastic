
helm repo add elastic https://helm.elastic.co
helm repo update

bash -c "
  export NAMESPACE=elastic-system
  envsubst < namespace.yaml | kubectl apply -f -
  envsubst < eck-trial.yaml | kubectl apply -f -
  "
bash -c "
  export NAMESPACE=elastic
  envsubst < namespace.yaml | kubectl apply -f -
  "

helm upgrade elastic-operator elastic/eck-operator \
  --install \
  -n elastic-system

helm upgrade dev elastic \
   --install \
   -n elastic

