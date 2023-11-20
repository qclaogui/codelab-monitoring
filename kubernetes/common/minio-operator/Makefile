include ../../../.bingo/Variables.mk

all: update build

.PHONY: update
update: $(KUSTOMIZE)
	@rm -rf charts/
	$(KUSTOMIZE) build --enable-helm . > k8s-all-in-one.yaml
	@cp -rf charts/operator/values.yaml .

.PHONY: build
build: $(KUSTOMIZE)
	$(KUSTOMIZE) build --enable-helm . > k8s-all-in-one.yaml

token:
	kubectl get secret/console-sa-secret -n minio-system -o json | jq -r ".data.token" | base64 -d
