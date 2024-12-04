# kubetail

Kubetail is a web-based, real-time log viewer for Kubernetes clusters

<a href="https://discord.gg/CmsmWAVkvX"><img src="https://img.shields.io/discord/1212031524216770650?logo=Discord&style=flat-square&logoColor=FFFFFF&labelColor=5B65F0&label=Discord&color=64B73A"></a>
[![slack](https://img.shields.io/badge/Slack-Join%20Our%20Community-364954?logo=slack&labelColor=4D1C51)](https://join.slack.com/t/kubetail/shared_invite/zt-2cq01cbm8-e1kbLT3EmcLPpHSeoFYm1w)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kubetail)](https://artifacthub.io/packages/search?repo=kubetail)

## Install

Before you can install you will need to add the `kubetail` repo to Helm:

```console
helm repo add kubetail https://kubetail-org.github.io/helm-charts/
```

After you've installed the repo you can create a new release from the `kubetail/kubetail` chart:

```console
helm install kubetail kubetail/kubetail --namespace kubetail --create-namespace
```

By default, the chart will autogenerate the required secrets (`KUBETAIL_DASHBOARD_CSRF_SECRET`, `KUBETAIL_DASHBOARD_SESSION_SECRET`) and
store them in a Kubernetes Secret to be re-used on subsequent upgrades.

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

| Name                                                 | Datatype | Description                           | Default                     |
| ---------------------------------------------------- | -------- | ------------------------------------- | --------------------------- |
| CHART:                                               |          |                                       |                             |
| `fullnameOverride`                                   | string   | Override chart's computed fullname    | null                        |
| `nameOverride`                                       | string   | Override chart's name                 | null                        |
| `namespaceOverride`                                  | string   | Override release's namespace          | null                        |
|                                                      |          |                                       |                             |
| KUBETAIL GENERAL:                                    |          |                                       |                             |
| `kubetail.authMode`                                  | string   | Auth mode (token, cluster, local)     | "cluster"                   |
| `kubetail.allowedNamespaces`                         | array    | Restricted namespaces                 | []                          |
| `kubetail.secrets.KUBETAIL_DASHBOARD_CSRF_SECRET`    | string   | B64-encoded value (autogen if null)   | null                        |
| `kubetail.secrets.KUBETAIL_DASHBOARD_SESSION_SECRET` | string   | B64-encoded value (autogen if null)   | null                        |
| `kubetail.global.annotations`                        | map      | Annotations for all resources         | {}                          |
| `kubetail.global.labels`                             | map      | Labels for all resources              | {}                          |
|                                                      |          |                                       |                             |
| KUBETAIL DASHBOARD:                                  |          |                                       |                             |
| `kubetail.dashboard.enabled`                         | bool     | Enable/disable dashboard              | true                        |
| `kubetail.dashboard.runtimeConfig`                   | map      | Dashboard runtime configuration       | *See values.yaml*           |
| `kubetail.dashboard.image.registry`                  | string   | Dashboard image registry              | docker.io                   |
| `kubetail.dashboard.image.repository`                | string   | Dashboard image repository            | kubetail/kubetail-dashboard |      
| `kubetail.dashboard.image.tag`                       | string   | Override image default tag            | *See values.yaml*           |
| `kubetail.dashboard.image.digest`                    | string   | Override image tag with digest        | null                        |
| `kubetail.dashboard.image.pullPolicy`                | string   | Kubernetes image pull policy          | "IfNotPresent"              |
| `kubetail.dashboard.container.name`                  | string   | Override chart's computed fullname    | null                        |
| `kubetail.dashboard.container.extraEnv`              | array    | Additional env                        | []                          |
| `kubetail.dashboard.container.extraEnvFrom`          | array    | Additional envFrom                    | []                          |
| `kubetail.dashboard.container.securityContext`       | map      | Dashboard container security context  | *See values.yaml*           |
| `kubetail.dashboard.container.resources`             | map      | Dashboard container resource limits   | {}                          |
| `kubetail.dashboard.podTemplate.annotations`         | map      | Additional annotations                | {}                          |
| `kubetail.dashboard.podTemplate.labels`              | map      | Additional labels                     | {}                          |
| `kubetail.dashboard.podTemplate.extraContainers`     | array    | Additional containers                 | []                          |
| `kubetail.dashboard.podTemplate.securityContext`     | map      | Dashboard pod security context        | {}                          |
| `kubetail.dashboard.podTemplate.env`                 | map      | Kubetail container additional env     | {}                          |
| `kubetail.dashboard.podTemplate.envFrom`             | map      | Kubetail container additional envFrom | {}                          |
| `kubetail.dashboard.podTemplate.affinity`            | map      | Pod affinity                          | {}                          |
| `kubetail.dashboard.podTemplate.nodeSelector`        | map      | Pod node selector                     | {}                          |
| `kubetail.dashboard.podTemplate.tolerations`         | array    | Pod tolerations                       | []                          |
| `kubetail.dashboard.configMap.name`                  | string   | Override chart's computed fullname    | null                        |
| `kubetail.dashboard.configMap.annotations`           | map      | Additional annotations                | {}                          |
| `kubetail.dashboard.configMap.labels`                | map      | Additional labels                     | {}                          |
| `kubetail.dashboard.deployment.name`                 | string   | Override chart's computed fullname    | null                        |
| `kubetail.dashboard.deployment.annotations`          | map      | Additional annotations                | {}                          |
| `kubetail.dashboard.deployment.labels`               | map      | Additional labels                     | {}                          |
| `kubetail.dashboard.deployment.replicas`             | int      | Number of replicas                    | 1                           |
| `kubetail.dashboard.deployment.revisionHistoryLimit` | int      | Revision history limit                | 5                           |
| `kubetail.dashboard.deployment.strategy`             | map      | Deployment strategy                   | *See values.yaml*           |
| `kubetail.dashboard.ingress.enabled`                 | bool     | If true, add Ingress resource         | false                       |
| `kubetail.dashboard.ingress.name`                    | string   | Override chart's computed fullname    | null                        |
| `kubetail.dashboard.ingress.annotations`             | map      | Additional annotations                | {}                          |
| `kubetail.dashboard.ingress.labels`                  | map      | Additional labels                     | {}                          |
| `kubetail.dashboard.ingress.rules`                   | array    | Ingress rules array                   | []                          |
| `kubetail.dashboard.ingress.tls`                     | array    | Ingress tls array                     | []                          |
| `kubetail.dashboard.ingress.className`               | string   | Ingress class name                    | null                        |
| `kubetail.dashboard.rbac.name`                       | string   | Override chart's computed fullname    | null                        |
| `kubetail.dashboard.rbac.annotations`                | map      | Additional annotations                | {}                          |
| `kubetail.dashboard.rbac.labels`                     | map      | Additional labels                     | {}                          |
| `kubetail.dashboard.secret.enabled`                  | bool     | If true, add Secret resource          | true                        |
| `kubetail.dashboard.secret.name`                     | string   | Override chart's computed fullname    | null                        |
| `kubetail.dashboard.secret.annotations`              | map      | Additional annotations                | {}                          |
| `kubetail.dashboard.secret.labels`                   | map      | Additional labels                     | {}                          |
| `kubetail.dashboard.service.name`                    | string   | Override chart's computed fullname    | null                        |
| `kubetail.dashboard.service.annotations`             | map      | Additional annotations                | {}                          |
| `kubetail.dashboard.service.labels`                  | map      | Additional labels                     | {}                          |
| `kubetail.dashboard.service.port`                    | int      | Service external port number          | 7500                        |
| `kubetail.dashboard.serviceAccount.name`             | string   | Override chart's computed fullname    | null                        |
| `kubetail.dashboard.serviceAccount.annotations`      | map      | Additional annotations                | {}                          |
| `kubetail.dashboard.serviceAccount.labels`           | map      | Additional labels                     | {}                          |
|                                                      |          |                                       |                             |
| KUBETAIL API:                                        |          |                                       |                             |
| `kubetail.api.enabled`                               | bool     | Enable/disable API                    | true                        |
| `kubetail.api.runtimeConfig`                         | map      | API runtime configuration             | *See values.yaml*           |
| `kubetail.api.image.registry`                        | string   | API image registry                    | docker.io                   |
| `kubetail.api.image.repository`                      | string   | API image repository                  | kubetail/kubetail-api       |      
| `kubetail.api.image.tag`                             | string   | Override image default tag            | *See values.yaml*           |
| `kubetail.api.image.digest`                          | string   | Override image tag with digest        | null                        |
| `kubetail.api.image.pullPolicy`                      | string   | Kubernetes image pull policy          | "IfNotPresent"              |
| `kubetail.api.container.name`                        | string   | Override chart's computed fullname    | null                        |
| `kubetail.api.container.extraEnv`                    | array    | Additional env                        | []                          |
| `kubetail.api.container.extraEnvFrom`                | array    | Additional envFrom                    | []                          |
| `kubetail.api.container.securityContext`             | map      | API container security context        | *See values.yaml*           |
| `kubetail.api.container.resources`                   | map      | API container resource limits         | {}                          |
| `kubetail.api.podTemplate.annotations`               | map      | Additional annotations                | {}                          |
| `kubetail.api.podTemplate.labels`                    | map      | Additional labels                     | {}                          |
| `kubetail.api.podTemplate.extraContainers`           | array    | Additional containers                 | []                          |
| `kubetail.api.podTemplate.securityContext`           | map      | API pod security context              | {}                          |
| `kubetail.api.podTemplate.env`                       | map      | Kubetail container additional env     | {}                          |
| `kubetail.api.podTemplate.envFrom`                   | map      | Kubetail container additional envFrom | {}                          |
| `kubetail.api.podTemplate.affinity`                  | map      | Pod affinity                          | {}                          |
| `kubetail.api.podTemplate.nodeSelector`              | map      | Pod node selector                     | {}                          |
| `kubetail.api.podTemplate.tolerations`               | array    | Pod tolerations                       | *See values.yaml*           |
| `kubetail.api.configMap.name`                        | string   | Override chart's computed fullname    | null                        |
| `kubetail.api.configMap.annotations`                 | map      | Additional annotations                | {}                          |
| `kubetail.api.configMap.labels`                      | map      | Additional labels                     | {}                          |
| `kubetail.api.deployment.name`                       | string   | Override chart's computed fullname    | null                        |
| `kubetail.api.deployment.annotations`                | map      | Additional annotations                | {}                          |
| `kubetail.api.deployment.labels`                     | map      | Additional labels                     | {}                          |
| `kubetail.api.deployment.replicas`                   | int      | Number of replicas                    | 1                           |
| `kubetail.api.deployment.revisionHistoryLimit`       | int      | Revision history limit                | 5                           |
| `kubetail.api.deployment.strategy`                   | map      | Deployment strategy                   | *See values.yaml*           |
| `kubetail.api.rbac.name`                             | string   | Override chart's computed fullname    | null                        |
| `kubetail.api.rbac.annotations`                      | map      | Additional annotations                | {}                          |
| `kubetail.api.rbac.labels`                           | map      | Additional labels                     | {}                          |
| `kubetail.api.service.name`                          | string   | Override chart's computed fullname    | null                        |
| `kubetail.api.service.annotations`                   | map      | Additional annotations                | {}                          |
| `kubetail.api.service.labels`                        | map      | Additional labels                     | {}                          |
| `kubetail.api.service.ports.grpc`                    | int      | Service external grpc port number     | 50051                       |
| `kubetail.api.serviceAccount.name`                   | string   | Override chart's computed fullname    | null                        |
| `kubetail.api.serviceAccount.annotations`            | map      | Additional annotations                | {}                          |
| `kubetail.api.serviceAccount.labels`                 | map      | Additional labels                     | {}                          |
|                                                      |          |                                       |                             |
| KUBETAIL AGENT:                                      |          |                                       |                             |
| `kubetail.agent.enabled`                             | bool     | Enable/disable agent                  | true                        |
| `kubetail.agent.runtimeConfig`                       | map      | Agent runtime configuration           | *See values.yaml*           |
| `kubetail.agent.image.registry`                      | string   | Agent image registry                  | docker.io                   |
| `kubetail.agent.image.repository`                    | string   | Agent image repository                | kubetail/kubetail-agent     |      
| `kubetail.agent.image.tag`                           | string   | Override image default tag            | *See values.yaml*           |
| `kubetail.agent.image.digest`                        | string   | Override image tag with digest        | null                        |
| `kubetail.agent.image.pullPolicy`                    | string   | Kubernetes image pull policy          | "IfNotPresent"              |
| `kubetail.agent.container.name`                      | string   | Override chart's computed fullname    | null                        |
| `kubetail.agent.container.extraEnv`                  | array    | Additional env                        | []                          |
| `kubetail.agent.container.extraEnvFrom`              | array    | Additional envFrom                    | []                          |
| `kubetail.agent.container.securityContext`           | map      | Agent container security context      | *See values.yaml*           |
| `kubetail.agent.container.resources`                 | map      | Agent container resource limits       | {}                          |
| `kubetail.agent.podTemplate.annotations`             | map      | Additional annotations                | {}                          |
| `kubetail.agent.podTemplate.labels`                  | map      | Additional labels                     | {}                          |
| `kubetail.agent.podTemplate.extraContainers`         | array    | Additional containers                 | []                          |
| `kubetail.agent.podTemplate.securityContext`         | map      | Agent pod security context            | {}                          |
| `kubetail.agent.podTemplate.env`                     | map      | Kubetail container additional env     | {}                          |
| `kubetail.agent.podTemplate.envFrom`                 | map      | Kubetail container additional envFrom | {}                          |
| `kubetail.agent.podTemplate.affinity`                | map      | Pod affinity                          | {}                          |
| `kubetail.agent.podTemplate.nodeSelector`            | map      | Pod node selector                     | {}                          |
| `kubetail.agent.podTemplate.tolerations`             | array    | Pod tolerations                       | *See values.yaml*           |
| `kubetail.agent.configMap.name`                      | string   | Override chart's computed fullname    | null                        |
| `kubetail.agent.configMap.annotations`               | map      | Additional annotations                | {}                          |
| `kubetail.agent.configMap.labels`                    | map      | Additional labels                     | {}                          |
| `kubetail.agent.daemonset.name`                      | string   | Override chart's computed fullname    | null                        |
| `kubetail.agent.daemonset.annotations`               | map      | Additional annotations                | {}                          |
| `kubetail.agent.daemonset.labels`                    | map      | Additional labels                     | {}                          |
| `kubetail.agent.rbac.name`                           | string   | Override chart's computed fullname    | null                        |
| `kubetail.agent.rbac.annotations`                    | map      | Additional annotations                | {}                          |
| `kubetail.agent.rbac.labels`                         | map      | Additional labels                     | {}                          |
| `kubetail.agent.service.name`                        | string   | Override chart's computed fullname    | null                        |
| `kubetail.agent.service.annotations`                 | map      | Additional annotations                | {}                          |
| `kubetail.agent.service.labels`                      | map      | Additional labels                     | {}                          |
| `kubetail.agent.serviceAccount.name`                 | string   | Override chart's computed fullname    | null                        |
| `kubetail.agent.serviceAccount.annotations`          | map      | Additional annotations                | {}                          |
| `kubetail.agent.serviceAccount.labels`               | map      | Additional labels                     | {}                          |
