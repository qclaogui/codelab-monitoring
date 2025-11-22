include ../../../../.bingo/Variables.mk

all: build

.PHONY: build
build: $(KUSTOMIZE)
	@$(KUSTOMIZE) build --helm-command $(HELM) --helm-kube-version ${helmKubeVersion} --enable-helm . > /dev/null
