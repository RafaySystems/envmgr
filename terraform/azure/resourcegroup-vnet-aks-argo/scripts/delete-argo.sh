cd /tmp
wget -q https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd-linux-amd64
mv argocd-linux-amd64 argocd
./argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD --config /tmp/argo-config
./argocd app delete $APP_NAME --grpc-web --config /tmp/argo-config
./argocd cluster rm $CLUSTER_NAME --yes --grpc-web --config /tmp/argo-config
