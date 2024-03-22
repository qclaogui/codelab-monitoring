include ../../../../.bingo/Variables.mk

all: build

.PHONY: build
build: $(KUSTOMIZE)
	@$(KUSTOMIZE) build --enable-helm . > /dev/null
