include ../../../../.bingo/Variables.mk

all: update build

.PHONY: update
update: $(KUSTOMIZE)
	@rm -rf charts/
	$(KUSTOMIZE) build --enable-helm . > k8s-all-in-one.yaml
	@cp -rf charts/tempo/values.yaml .

.PHONY: build
build: $(KUSTOMIZE)
	@$(KUSTOMIZE) build --enable-helm . > k8s-all-in-one.yaml