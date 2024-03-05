include ../../../../.bingo/Variables.mk

all: build

.PHONY: build
build: $(KUSTOMIZE)
	@$(KUSTOMIZE) build --enable-helm . > k8s-all-in-one.yaml
