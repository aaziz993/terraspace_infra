for ns in $(microk8s kubectl get ns --field-selector status.phase=Terminating -o jsonpath='{.items[*].metadata.name}')
do
  microk8s kubectl get ns $ns -ojson | jq '.spec.finalizers = []' | microk8s kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f -
done

for ns in $(microk8s kubectl get ns --field-selector status.phase=Terminating -o jsonpath='{.items[*].metadata.name}')
do
  microk8s kubectl get ns $ns -ojson | jq '.metadata.finalizers = []' | microk8s kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f -
done
