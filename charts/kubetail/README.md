# kubetail

Kubetail is a web-based, real-time log viewer for Kubernetes clusters

[![slack](https://img.shields.io/badge/Slack-Join%20Our%20Community-364954?logo=slack&labelColor=4D1C51)](https://join.slack.com/t/kubetail/shared_invite/zt-2cq01cbm8-e1kbLT3EmcLPpHSeoFYm1w)

## Install

Before you can install you will need to add the `kubetail` repo to Helm:

```console
helm repo add kubetail https://kubetail-org.github.io/helm-charts/
```

After you've installed the repo you can create a new release from the `kubetail/kubetail` chart:

```console
helm install kubetail kubetail/kubetail --namespace kubetail --create-namespace
```

By default, the chart will autogenerate the required secrets (`KUBETAIL_CSRF_SECRET`, `KUBETAIL_SESSION_SECRET`) and
store them in a kubernetes Secret resource to be used on subsequent upgrades.

## Upgrade

First make sure helm has the latest version of the `kubetail` repo:

```console
helm repo update kubetail
```

Next use the `helm upgrade` command:

```console
helm upgrade kubetail kubetail/kubetail --namespace kubetail
```

## Uninstall

To uninstall, use the `helm uninstall` command:

```console
helm uninstall kubetail --namespace kubetail
```

## Configuration

These are the configurable parameters for the kubetail chart and their default values:

| Name                                                   | Datatype | Description                            | Default           |
| ------------------------------------------------------ | -------- | -------------------------------------- | ----------------- |
| GENERAL:                                               |          |                                        |                   |
| `fullnameOverride`                                     | string   | Override the chart's computed fullname | null              |
| `nameOverride`                                         | string   | Override chart's name                  | null              |
| `namespaceOverride`                                    | string   | Override release's namespace           | null              |
|                                                        |          |                                        |                   |
| KUBETAIL:                                              |          |                                        |                   |
| `kubetail.authMode`                                    | string   | Auth mode (token, cluster, local)      | "cluster"         |
| `kubetail.config`                                      | string   | Kubetail dashboard config contents     | *See values.yaml* |
| `kubetail.image.registry`                              | string   | Image registry                         | docker.io         |
| `kubetail.image.repository`                            | string   | Image repository                       | kubetail/kubetail |
| `kubetail.image.tag`                                   | string   | Override chart's appVersion            | null              |
| `kubetail.image.digest`                                | string   | Override image tag                     | null              |
| `kubetail.image.pullPolicy`                            | string   | Kubernetes image pull policy           | "IfNotPresent"    |
| `kubetail.clusterRole.name`                            | string   | Override chart's computed fullname     | null              |
| `kubetail.clusterRole.annotations`                     | map      | Additional annotations                 | {}                |
| `kubetail.clusterRole.labels`                          | map      | Additional labels                      | {}                |
| `kubetail.clusterRoleBinding.name`                     | string   | Override chart's computed fullname     | null              |
| `kubetail.clusterRoleBinding.annotations`              | map      | Additional annotations                 | {}                |
| `kubetail.clusterRoleBinding.labels`                   | map      | Additional labels                      | {}                |
| `kubetail.configMap.name`                              | string   | Override chart's computed fullname     | null              |
| `kubetail.configMap.annotations`                       | map      | Additional annotations                 | {}                |
| `kubetail.configMap.labels`                            | map      | Additional labels                      | {}                |
| `kubetail.deployment.name`                             | string   | Override chart's computed fullname     | null              |
| `kubetail.deployment.annotations`                      | map      | Additional annotations                 | {}                |
| `kubetail.deployment.labels`                           | map      | Additional labels                      | {}                |
| `kubetail.deployment.replicas`                         | int      | Number of replicas                     | 1                 |
| `kubetail.deployment.revisionHistoryLimit`             | int      | Revision history limit                 | 5                 |
| `kubetail.deployment.strategy`                         | map      | Deployment strategy                    | *See values.yaml* |
| `kubetail.ingress.enabled`                             | bool     | If true, add Ingress resource          | false             |
| `kubetail.ingress.name`                                | string   | Override chart's computed fullname     | null              |
| `kubetail.ingress.annotations`                         | map      | Additional annotations                 | {}                |
| `kubetail.ingress.labels`                              | map      | Additional labels                      | {}                |
| `kubetail.ingress.rules`                               | array    | Ingress rules array                    | []                |
| `kubetail.ingress.tls`                                 | array    | Ingress tls array                      | []                |
| `kubetail.podTemplate.annotations`                     | map      | Additional annotations                 | {}                |
| `kubetail.podTemplate.labels`                          | map      | Additional labels                      | {}                |
| `kubetail.podTemplate.affinity`                        | map      | Pod affinity                           | {}                |
| `kubetail.podTemplate.automountServiceAccountToken`    | bool     | Pod attribute value                    | true              |
| `kubetail.podTemplate.env`                             | map      | Kubetail container additional env      | {}                |
| `kubetail.podTemplate.envFrom`                         | map      | Kubetail container additional envFrom  | {}                |
| `kubetail.podTemplate.args`                            | array    | Kubetail container additional args     | []                |
| `kubetail.podTemplate.port`                            | int      | Kubetail container port                | 4000              |
| `kubetail.podTemplate.livenessProbe`                   | map      | Kubetail container livenessProbe       | *See values.yaml* |
| `kubetail.podTemplate.readinessProbe`                  | map      | Kubetail container readinessProbe      | *See values.yaml* |
| `kubetail.podTemplate.resources`                       | map      | Kubetail container resources           | {}                |
| `kubetail.podTemplate.securityContext`                 | map      | Pod securityContext                    | *See values.yaml* |
| `kubetail.podTemplate.containerSecurityContext`        | map      | Kubetail container securityContext     | *See values.yaml* |
| `kubetail.podTemplate.volumes`                         | array    | Pod volumes                            | []                |
| `kubetail.podTemplate.volumeMounts`                    | array    | Kubetail container volumeMounts        | []                |
| `kubetail.podTemplate.priorityClassName`               | string   | Pod priorityClassName                  | null              |
| `kubetail.podTemplate.nodeSelector`                    | map      | Pod node selector                      | {}                |
| `kubetail.podTemplate.tolerations`                     | array    | Pod tolerations                        | []                |
| `kubetail.secret.enabled`                              | bool     | If true, add Secret resource           | true              |
| `kubetail.secret.name`                                 | string   | Override chart's computed fullname     | null              |
| `kubetail.secret.annotations`                          | map      | Additional annotations                 | {}                |
| `kubetail.secret.labels`                               | map      | Additional labels                      | {}                |
| `kubetail.secret.KUBETAIL_CSRF_SECRET`                 | string   | B64-encoded value (autogen if null)    | null              |
| `kubetail.secret.KUBETAIL_SESSION_SECRET`              | string   | B64-encoded value (autogen if null)    | null              |
| `kubetail.service.name`                                | string   | Override chart's computed fullname     | null              |
| `kubetail.service.annotations`                         | map      | Additional annotations                 | {}                |
| `kubetail.service.labels`                              | map      | Additional labels                      | {}                |
| `kubetail.service.port`                                | int      | Service port number                    | 80                |
| `kubetail.serviceAccount.name`                         | string   | Override chart's computed fullname     | null              |
| `kubetail.serviceAccount.annotations`                  | map      | Additional annotations                 | {}                |
| `kubetail.serviceAccount.labels`                       | map      | Additional labels                      | {}                |
| `kubetail.serviceAccount.automountServiceAccountToken` | bool     | Resource's attribute value             | true              |
