JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s

all: fmt prom_alerts.yaml prom_rules.yaml dashboards_out

fmt:
	@find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		xargs -n 1 -- $(JSONNET_FMT) -i

prom_alerts.yaml:
	jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusAlerts)' > deploy/$@

prom_rules.yaml:
	jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusRules)'  > deploy/$@

dashboards_out:
	@mkdir -p deploy/dashboards_out deploy/manifests
	jsonnet -J vendor -e '(import "mixin.libsonnet").grafanaDashboards' -m deploy/dashboards_out
	kustomize build deploy > deploy/manifests/k8s-all-in-one.yaml

#lint: prom_alerts.yaml prom_rules.yaml
#	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
#		while read f; do \
#			$(JSONNET_FMT) "$$f" | diff -u "$$f" -; \
#		done
#
#	promtool check rules prom_alerts.yaml prom_rules.yaml

clean:
	rm -rf deploy/dashboards_out deploy/manifests deploy/prom_alerts.yaml deploy/prom_rules.yaml

local:
	# local
	mimirtool rules load --id=0 --address=http://127.0.0.1:30080 deploy/prom_rules.yaml
	mimirtool rules load --id=0 --address=http://127.0.0.1:30080 deploy/prom_alerts.yaml
	# am
	#mimirtool alertmanager --id=0 --address=http://127.0.0.1:30080 load deploy/alertmanager.yaml deploy/default.tmpl
	#mimirtool alertmanager --id=0 --address=http://127.0.0.1:30080 get
	#mimirtool alertmanager --id=0 --address=http://127.0.0.1:30080 delete