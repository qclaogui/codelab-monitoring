include ../../../../.bingo/Variables.mk

all: update build

.PHONY: update
update: $(KUSTOMIZE)
	@rm -rf charts/
	$(KUSTOMIZE) build --enable-helm . > /dev/null
	@cp -rf charts/*/values.yaml . > /dev/null 2>&1 || (cp -rf charts/*/*/values.yaml . && true)

.PHONY: build
build: $(KUSTOMIZE)
	@$(KUSTOMIZE) build --enable-helm . > /dev/null
