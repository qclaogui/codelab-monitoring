include ../../../../.bingo/Variables.mk

all: update build

.PHONY: update
update: $(KUSTOMIZE)
	@rm -rf charts/
	$(KUSTOMIZE) build --helm-command $(HELM) --helm-kube-version ${helmKubeVersion} --enable-helm . > /dev/null
	@cp -rf charts/*/values.yaml . > /dev/null 2>&1 || (cp -rf charts/*/*/values.yaml . && true)

.PHONY: build
build: $(KUSTOMIZE)
	@$(KUSTOMIZE) build --helm-command $(HELM) --helm-kube-version ${helmKubeVersion} --enable-helm . > /dev/null
