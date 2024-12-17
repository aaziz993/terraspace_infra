select crd in $(microk8s kubectl get crd --no-headers -o custom-columns=":metadata.name" --sort-by=.metadata.name)
do
    microk8s kubectl patch crd/$crd -p '{"metadata":{"finalizers":[]}}' --type=merge
    break
done
