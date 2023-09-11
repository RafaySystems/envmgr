curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd-linux-amd64
mv argocd-linux-amd64 argocd
./argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD
./argocd cluster add --kubeconfig /tmp/kubeconfig $CLUSTER_NAME --yes --grpc-web
./argocd app create $APP_NAME --repo https://github.com/RafaySystems/demo-apps --path Helm/webserver --dest-name $CLUSTER_NAME --dest-namespace $APP_NAMESPACE --grpc-web
./argocd app sync argo-demo --grpc-web
./argocd app set argo-demo --sync-policy automated --grpc-web