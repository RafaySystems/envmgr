REPO_URL := public.ecr.aws/rafay-dev/gen-ai-sample-chat-app


.PHONY: local-setup
local-setup:
	python3 -m venv venv
	venv/bin/pip install --upgrade pip setuptools wheel
	venv/bin/pip install -r requirements.txt

.PHONY: local-run
local-run:
	venv/bin/chainlit run -h app.py

.PHONY: run
run:
	docker build -t gen-ai-sample-chat-app .
	docker run -it --rm -v ${HOME}/.aws:/home/nonroot/.aws:ro --publish 8000:8000 gen-ai-sample-chat-app

.PHONY: push
push:
	@test -n "$(NEXT_VERSION)" || (echo "NEXT_VERSION is not set" && exit 1)
	docker buildx build --platform=linux/amd64,linux/arm64 --tag=$(REPO_URL):$(NEXT_VERSION) --tag=$(REPO_URL):latest --provenance=false --push .
