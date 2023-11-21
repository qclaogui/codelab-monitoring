include ../../../.bingo/Variables.mk

all: update build

.PHONY: update
update: $(KUSTOMIZE)
	@rm -rf charts/
	$(KUSTOMIZE) build --enable-helm . > k8s-all-in-one.yaml
	@cp -rf charts/grafana-agent/values.yaml .

.PHONY: build
build: $(KUSTOMIZE)
	@$(KUSTOMIZE) build --enable-helm . > k8s-all-in-one.yaml

CONFIG_FILES = configs/config.river $(wildcard configs/modules/*.river)
CONFIG_FILES_IN_DOCKER = $(subst configs/,/data/configs/,$(CONFIG_FILES))

# echo "******************** grafana-agent fmt $$c ********************"; \
.PHONY: fmt
fmt: # Uses Grafana Agent to fmt the river config
	@for c in $(CONFIG_FILES_IN_DOCKER); do \
		docker run -e AGENT_MODE=flow --rm --volume "$(shell pwd):/data" -u $(shell id -u) grafana/agent:v0.37.4 fmt -w $$c ; \
	done
