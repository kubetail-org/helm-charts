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

By default, the chart will autogenerate the required secrets (`KUBETAIL_SERVER_CSRF_SECRET`, `KUBETAIL_SERVER_SESSION_SECRET`) and
store them in a kubernetes Secret to be used on subsequent upgrades.

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

| Name                                              | Datatype | Description                            | Default                  |
| ------------------------------------------------- | -------- | -------------------------------------- | ------------------------ |
| CHART:                                            |          |                                        |                          |
| `fullnameOverride`                                | string   | Override the chart's computed fullname | null                     |
| `nameOverride`                                    | string   | Override chart's name                  | null                     |
| `namespaceOverride`                               | string   | Override release's namespace           | null                     |
|                                                   |          |                                        |                          |
| KUBETAIL GENERAL:                                 |          |                                        |                          |
| `kubetail.authMode`                               | string   | Auth mode (token, cluster, local)      | "cluster"                |
| `kubetail.allowedNamespaces`                      | array    | Restricted namespaces                  | []                       |
| `kubetail.secrets.KUBETAIL_SERVER_CSRF_SECRET`    | string   | B64-encoded value (autogen if null)    | null                     |
| `kubetail.secrets.KUBETAIL_SERVER_SESSION_SECRET` | string   | B64-encoded value (autogen if null)    | null                     |
| `kubetail.global.annotations`                     | map      | Annotations for all resources          | {}                       |
| `kubetail.global.labels`                          | map      | Labels for all resources               | {}                       |
|                                                   |          |                                        |                          |
| KUBETAIL SERVER:                                  |          |                                        |                          |
| `kubetail.server.runtimeConfig`                   | map      | Server runtime configuration           | *See values.yaml*        |
| `kubetail.server.image.registry`                  | string   | Server image registry                  | docker.io                |
| `kubetail.server.image.repository`                | string   | Server image repository                | kubetail/kubetail-server |      
| `kubetail.server.image.tag`                       | string   | Override chart's appVersion            | null                     |
| `kubetail.server.image.digest`                    | string   | Override image tag                     | null                     |
| `kubetail.server.image.pullPolicy`                | string   | Kubernetes image pull policy           | "IfNotPresent"           |
| `kubetail.server.container.name`                  | string   | Override chart's computed fullname     | null                     |
| `kubetail.server.container.extraEnv`              | array    | Additional env                         | []                       |
| `kubetail.server.container.extraEnvFrom`          | array    | Additional envFrom                     | []                       |
| `kubetail.server.container.securityContext`       | map      | Server container security context      | *See values.yaml*        |
| `kubetail.server.container.resources`             | map      | Server container resource limits       | {}                       |
| `kubetail.server.podTemplate.annotations`         | map      | Additional annotations                 | {}                       |
| `kubetail.server.podTemplate.labels`              | map      | Additional labels                      | {}                       |
| `kubetail.server.podTemplate.extraContainers`     | array    | Additional containers                  | []                       |
| `kubetail.server.podTemplate.securityContext`     | map      | Server pod security context            | {}                       |
| `kubetail.server.podTemplate.env`                 | map      | Kubetail container additional env      | {}                       |
| `kubetail.server.podTemplate.envFrom`             | map      | Kubetail container additional envFrom  | {}                       |
| `kubetail.server.podTemplate.affinity`            | map      | Pod affinity                           | {}                       |
| `kubetail.server.podTemplate.nodeSelector`        | map      | Pod node selector                      | {}                       |
| `kubetail.server.podTemplate.tolerations`         | array    | Pod tolerations                        | []                       |
| `kubetail.server.configMap.name`                  | string   | Override chart's computed fullname     | null                     |
| `kubetail.server.configMap.annotations`           | map      | Additional annotations                 | {}                       |
| `kubetail.server.configMap.labels`                | map      | Additional labels                      | {}                       |
| `kubetail.server.deployment.name`                 | string   | Override chart's computed fullname     | null                     |
| `kubetail.server.deployment.annotations`          | map      | Additional annotations                 | {}                       |
| `kubetail.server.deployment.labels`               | map      | Additional labels                      | {}                       |
| `kubetail.server.deployment.replicas`             | int      | Number of replicas                     | 1                        |
| `kubetail.server.deployment.revisionHistoryLimit` | int      | Revision history limit                 | 5                        |
| `kubetail.server.deployment.strategy`             | map      | Deployment strategy                    | *See values.yaml*        |
| `kubetail.server.ingress.enabled`                 | bool     | If true, add Ingress resource          | false                    |
| `kubetail.server.ingress.name`                    | string   | Override chart's computed fullname     | null                     |
| `kubetail.server.ingress.annotations`             | map      | Additional annotations                 | {}                       |
| `kubetail.server.ingress.labels`                  | map      | Additional labels                      | {}                       |
| `kubetail.server.ingress.rules`                   | array    | Ingress rules array                    | []                       |
| `kubetail.server.ingress.tls`                     | array    | Ingress tls array                      | []                       |
| `kubetail.server.ingress.className`               | string   | Ingress class name                     | null                     |
| `kubetail.server.rbac.name`                       | string   | Override chart's computed fullname     | null                     |
| `kubetail.server.rbac.annotations`                | map      | Additional annotations                 | {}                       |
| `kubetail.server.rbac.labels`                     | map      | Additional labels                      | {}                       |
| `kubetail.server.secret.enabled`                  | bool     | If true, add Secret resource           | true                     |
| `kubetail.server.secret.name`                     | string   | Override chart's computed fullname     | null                     |
| `kubetail.server.secret.annotations`              | map      | Additional annotations                 | {}                       |
| `kubetail.server.secret.labels`                   | map      | Additional labels                      | {}                       |
| `kubetail.server.service.name`                    | string   | Override chart's computed fullname     | null                     |
| `kubetail.server.service.annotations`             | map      | Additional annotations                 | {}                       |
| `kubetail.server.service.labels`                  | map      | Additional labels                      | {}                       |
| `kubetail.server.service.port`                    | int      | Service external port number           | 80                       |
| `kubetail.server.serviceAccount.name`             | string   | Override chart's computed fullname     | null                     |
| `kubetail.server.serviceAccount.annotations`      | map      | Additional annotations                 | {}                       |
| `kubetail.server.serviceAccount.labels`           | map      | Additional labels                      | {}                       |
|                                                   |          |                                        |                          |
| KUBETAIL AGENT:                                   |          |                                        |                          |
| `kubetail.agent.runtimeConfig`                    | map      | Agent runtime configuration            | *See values.yaml*        |
| `kubetail.agent.image.registry`                   | string   | Agent image registry                   | docker.io                |
| `kubetail.agent.image.repository`                 | string   | Agent image repository                 | kubetail/kubetail-agent  |      
| `kubetail.agent.image.tag`                        | string   | Override chart's appVersion            | null                     |
| `kubetail.agent.image.digest`                     | string   | Override image tag                     | null                     |
| `kubetail.agent.image.pullPolicy`                 | string   | Kubernetes image pull policy           | "IfNotPresent"           |
| `kubetail.agent.container.name`                   | string   | Override chart's computed fullname     | null                     |
| `kubetail.agent.container.extraEnv`               | array    | Additional env                         | []                       |
| `kubetail.agent.container.extraEnvFrom`           | array    | Additional envFrom                     | []                       |
| `kubetail.agent.container.securityContext`        | map      | Agent container security context       | *See values.yaml*        |
| `kubetail.agent.container.resources`              | map      | Agent container resource limits        | {}                       |
| `kubetail.agent.podTemplate.annotations`          | map      | Additional annotations                 | {}                       |
| `kubetail.agent.podTemplate.labels`               | map      | Additional labels                      | {}                       |
| `kubetail.agent.podTemplate.extraContainers`      | array    | Additional containers                  | []                       |
| `kubetail.agent.podTemplate.securityContext`      | map      | Agent pod security context             | {}                       |
| `kubetail.agent.podTemplate.env`                  | map      | Kubetail container additional env      | {}                       |
| `kubetail.agent.podTemplate.envFrom`              | map      | Kubetail container additional envFrom  | {}                       |
| `kubetail.agent.podTemplate.affinity`             | map      | Pod affinity                           | {}                       |
| `kubetail.agent.podTemplate.nodeSelector`         | map      | Pod node selector                      | {}                       |
| `kubetail.agent.podTemplate.tolerations`          | array    | Pod tolerations                        | *See values.yaml*        |
| `kubetail.agent.configMap.name`                   | string   | Override chart's computed fullname     | null                     |
| `kubetail.agent.configMap.annotations`            | map      | Additional annotations                 | {}                       |
| `kubetail.agent.configMap.labels`                 | map      | Additional labels                      | {}                       |
| `kubetail.agent.deployment.name`                  | string   | Override chart's computed fullname     | null                     |
| `kubetail.agent.deployment.annotations`           | map      | Additional annotations                 | {}                       |
| `kubetail.agent.deployment.labels`                | map      | Additional labels                      | {}                       |
| `kubetail.agent.deployment.replicas`              | int      | Number of replicas                     | 1                        |
| `kubetail.agent.deployment.revisionHistoryLimit`  | int      | Revision history limit                 | 5                        |
| `kubetail.agent.deployment.strategy`              | map      | Deployment strategy                    | *See values.yaml*        |
| `kubetail.agent.ingress.enabled`                  | bool     | If true, add Ingress resource          | false                    |
| `kubetail.agent.ingress.name`                     | string   | Override chart's computed fullname     | null                     |
| `kubetail.agent.ingress.annotations`              | map      | Additional annotations                 | {}                       |
| `kubetail.agent.ingress.labels`                   | map      | Additional labels                      | {}                       |
| `kubetail.agent.ingress.rules`                    | array    | Ingress rules array                    | []                       |
| `kubetail.agent.ingress.tls`                      | array    | Ingress tls array                      | []                       |
| `kubetail.agent.ingress.className`                | string   | Ingress class name                     | null                     |
| `kubetail.agent.rbac.name`                        | string   | Override chart's computed fullname     | null                     |
| `kubetail.agent.rbac.annotations`                 | map      | Additional annotations                 | {}                       |
| `kubetail.agent.rbac.labels`                      | map      | Additional labels                      | {}                       |
| `kubetail.agent.secret.enabled`                   | bool     | If true, add Secret resource           | true                     |
| `kubetail.agent.secret.name`                      | string   | Override chart's computed fullname     | null                     |
| `kubetail.agent.secret.annotations`               | map      | Additional annotations                 | {}                       |
| `kubetail.agent.secret.labels`                    | map      | Additional labels                      | {}                       |
| `kubetail.agent.service.name`                     | string   | Override chart's computed fullname     | null                     |
| `kubetail.agent.service.annotations`              | map      | Additional annotations                 | {}                       |
| `kubetail.agent.service.labels`                   | map      | Additional labels                      | {}                       |
| `kubetail.agent.serviceAccount.name`              | string   | Override chart's computed fullname     | null                     |
| `kubetail.agent.serviceAccount.annotations`       | map      | Additional annotations                 | {}                       |
| `kubetail.agent.serviceAccount.labels`            | map      | Additional labels                      | {}                       |
