include ../../../.bingo/Variables.mk

all: update build

.PHONY: update
update: $(KUSTOMIZE)
	$(KUSTOMIZE) build --enable-helm . > k8s-all-in-one.yaml
	@cp -rf charts/kube-prometheus-stack/values.yaml .
	@rm -rf charts/

.PHONY: build
build: $(KUSTOMIZE)
	$(KUSTOMIZE) build --enable-helm . > k8s-all-in-one.yaml
	@rm -rf charts/