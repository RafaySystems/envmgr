CLUSTER_NAME=$1
APP_NAME=$2
ARGOCD_SERVER=$3
ARGOCD_USERNAME=$4
ARGOCD_PASSWORD=$5
cd /tmp
wget -q https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd-linux-amd64
mv argocd-linux-amd64 argocd
./argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD --config /tmp/argo-config
./argocd app delete $APP_NAME --grpc-web --config /tmp/argo-config
./argocd cluster rm $CLUSTER_NAME --yes --grpc-web --config /tmp/argo-config
