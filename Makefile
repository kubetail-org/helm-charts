.PHONY: lint

lint:
	# Default values
	helm lint charts/kubetail

	# Allowed namespaces
	helm lint charts/kubetail \
		--set kubetail.allowedNamespaces="{ns1,ns2}"

	# Global labels
	helm lint charts/kubetail \
		--set kubetail.global.labels.key1=val1 \
		--set kubetail.global.labels.key2=val2

	# Disable dashboard
	helm lint charts/kubetail \
		--set kubetail.dashboard.enable=false

	# Disable cluster api
	helm lint charts/kubetail \
		--set kubetail.clusterAPI.enable=false

	# Disable cluster agent
	helm lint charts/kubetail \
		--set kubetail.clusterAgent.enable=false
