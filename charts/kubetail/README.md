# kubetail

Kubetail is a web-based, real-time log viewer for Kubernetes clusters

[![slack](https://img.shields.io/badge/Slack-Join%20Our%20Community-364954?logo=slack&labelColor=4D1C51)](https://join.slack.com/t/kubetail/shared_invite/zt-2cq01cbm8-e1kbLT3EmcLPpHSeoFYm1w)

## Install

Before you can install you will need to add the `kubetail` repo to Helm:

```sh
helm repo add kubetail https://kubetail-org.github.io/helm/
```

After you've installed the repo you can create a new release from the `kubetail/kubetail` chart:

```sh
helm install kubetail kubetail/kubetail --namespace kubetail --create-namespace
```

## Upgrade

First make sure helm has the latest version of the `kubetail` repo:

```sh
helm repo update kubetail
```

Next use the `helm upgrade` command:

```sh
helm upgrade kubetail kubetail/kubetail --namespace kubetail
```

## Uninstall

To uninstall, use the `helm uninstall` command:

```sh
helm uninstall kubetail --namespace kubetail
```

## Configuration

These are the configurable parameters for the kubetail chart and their default values:

| Name                                         | Datatype | Description                                          | Default             |
| -------------------------------------------- | -------- | ---------------------------------------------------- | ------------------- |
| nameOverride                                 | string   | Override name of the chart                           |                     |
| fullnameOverride                             | string   | Override full name of chart+release                  |                     |
| namespaceOverride                            | string   | Override the release namespace                       |                     |
| authMode                                     | string   | Auth mode (token, cluster, local)                    | "cluster"           |
| labels                                       | map      | Labels to apply to all resources                     | {}                  |
| image.registry                               | string   | Registry to use for container image                  | "kubetail/kubetail" |
| image.tag                                    | string   | Override chart app version                           |                     |
| image.pullPolicy                             | string   | Override default container imagePullPolicy           |                     |
| clusterRole.name                             | string   | Override ClusterRole name from release               |                     |
| clusterRoleBinding.name                      | string   | Override ClusterRoleBinding name from release        |                     |
| clusterRoleBinding.rules                     | array    | Override ClusterRoleBinding rules                    | *See values.yaml*   |
| configMap.name                               | string   | Override ConfigMap name from release                 |                     |
| deployment.name                              | string   | Override Deployment name from release                |                     |
| deployment.replicas                          | int      | Deployment replicas                                  | 1                   |
| deployment.revisionHistoryLimit              | int      | Deployment revisionHistoryLimit                      | 10                  |
| deployment.updateStrategy                    | map      | Deployment updateStrategy                            |                     |
| deployment.containerPort                     | int      | Deployment kubetail container's containerPort        | 4000                |
| deployment.args                              | array    | Deployment kubetail container args                   | *See values.yaml*   |
| deployment.livenessProbe.httpGet.scheme      | string   | Deployment liveness probe http scheme                | HTTP                |
| deployment.livenessProbe.httpGet.path        | string   | Deployment liveness probe http path                  | "/healthz"          |
| deployment.livenessProbe.httpGet.port        | int      | Deployment liveness probe http port                  | 4000                |
| deployment.livenessProbe.initialDelaySeconds | int      | Deployment liveness probe initialDelaySeconds        | 30                  |
| deployment.livenessProbe.timeoutSeconds      | int      | Deployment liveness probe timeoutSeconds             | 30                  |
| deployment.livenessProbe.periodSeconds       | int      | Deployment liveness probe periodSeconds              | 10                  |
| deployment.livenessProbe.failureThreshold    | int      | Deployment liveness probe failureThreshold           | 3                   |
| deployment.resources.requests.cpu            | string   | Deployment cpu resource request                      | 100m                |
| deployment.resources.requests.memory         | string   | Deployment memory resource request                   | 100Mi               |
| service.name                                 | string   | Override Service name from release                   |                     |
| service.type                                 | string   | Service type                                         | ClusterIP           |
| service.port                                 | int      | Service port                                         | 4000                |
| serviceAccount.name                          | string   | Override ServiceAccount name from release            |                     |
| ingress.enabled                              | bool     | Enable ingress resource                              | false               |
| ingress.name                                 | string   | Override ingress name                                |                     |
| ingress.annotations                          | map      | Annocations to apply to ingress resource             | {}                  |
| ingress.hosts                                | array    | Hosts array for ingress resource                     | []                  |
| ingress.tls                                  | array    | TlS array for ingress resource                       | []                  |
| ingress.secretName                           | string   | Override ingress secretName                          |                     |
| config                                       | map      | Kubetail app config                                  | *See values.yaml*   |
