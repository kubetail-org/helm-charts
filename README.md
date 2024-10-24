# Kubetail Helm Charts

<a href="https://discord.gg/pXHXaUqt"><img src="https://img.shields.io/discord/1212031524216770650?logo=Discord&style=flat-square&logoColor=FFFFFF&labelColor=5B65F0&label=Discord&color=64B73A"></a>
[![slack](https://img.shields.io/badge/Slack-kubetail-364954?logo=slack&labelColor=4D1C51)](https://join.slack.com/t/kubetail/shared_invite/zt-2cq01cbm8-e1kbLT3EmcLPpHSeoFYm1w)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kubetail)](https://artifacthub.io/packages/search?repo=kubetail)

## Quickstart

Add this repo to helm:

```console
helm repo add kubetail https://kubetail-org.github.io/helm-charts/
helm repo update
helm search repo kubetail
```

Next steps:

```console
# install into the default namespace
helm install kubetail kubetail/kubetail

# install into a new namespace
helm install kubetail kubetail/kubetail --namespace kubetail-system --create-namespace

# install using custom values
helm install kubetail kubetail/kubetail --namespace kubetail-system --create-namespace --values ~/path/to/values.yaml

# upgrade an existing installation
helm upgrade kubetail kubetail/kubetail --namespace kubetail-system

# uninstall
helm uninstall kubetail --namespace kubetail-system
```
