cd /tmp
curl -H "X-Engine-Helper-Token:$DOWNLOAD_TOKEN" -o ./job.tar.zst "$DOWNLOAD_URL"
unzstd ./job.tar.zst
mkdir terraform
tar -xf job.tar -C ./terraform
ls -al ./terraform
infracost breakdown --path ./terraform/$REPO_PATH
