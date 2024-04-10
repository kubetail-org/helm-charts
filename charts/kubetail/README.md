# kubetail

Kubetail is a web-based, real-time log viewer for Kubernetes clusters

[![slack](https://img.shields.io/badge/Slack-Join%20Our%20Community-364954?logo=slack&labelColor=4D1C51)](https://join.slack.com/t/kubetail/shared_invite/zt-2cq01cbm8-e1kbLT3EmcLPpHSeoFYm1w)

## Install

Before you can install you will need to add the `kubetail` repo to Helm:

```console
helm repo add kubetail https://kubetail-org.github.io/helm/
```

After you've installed the repo you can create a new release from the `kubetail/kubetail` chart:

```console
helm install kubetail kubetail/kubetail --namespace kubetail --create-namespace
```

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

| Name                                                     | Datatype | Description                                  | Default                   |
| -------------------------------------------------------- | -------- | -------------------------------------------- | ------------------------- |
| GENERAL:                                                 |          |                                              |                           |
| `global.annotations`                                     | map      | Annotations to apply to all resources        | {}                        |
| `global.labels`                                          | array    | Labels to apply to all resources             | []                        |
| `override.name`                                          | string   | Override name of the chart                   | nil                       |
| `override.fullname`                                      | string   | Override full name of chart+release          | nil                       |
| `override.namespace`                                     | string   | Override the release namespace               | nil                       |
|                                                          |          |                                              |                           |
| DASHBOARD:                                               |          |                                              |                           |
| `dashboard.authMode`                                     | string   | Auth mode (token, cluster, local)            | "cluster"                 |
| `dashboard.config`                                       | map      | Kubetail dashboard config                    | *See values.yaml*         |
| `dashboard.clusterRole.metadata.extraAnnotations`        | map      | Extra annotations to apply to resource       | {}                        |
| `dashboard.clusterRole.metadata.extraLabels`             | array    | Extra labels to apply to resource            | []                        |
| `dashboard.clusterRole.metadata.name`                    | string   | Override resource name from release          | nil                       |
| `dashboard.clusterRole.rules`                            | map      | ClusterRole rules                            | *See values.yaml*         |
| `dashboard.clusterRoleBinding.metadata.extraAnnotations` | map      | Extra annotations to apply to resource       | {}                        |
| `dashboard.clusterRoleBinding.metadata.extraLabels`      | array    | Extra labels to apply to resource            | []                        |
| `dashboard.clusterRoleBinding.metadata.name`             | string   | Override resource name from release          | nil                       |
| `dashboard.configMap.metadata.extraAnnotations`          | map      | Extra annotations to apply to resource       | {}                        |
| `dashboard.configMap.metadata.extraLabels`               | array    | Extra labels to apply to resource            | []                        |
| `dashboard.configMap.metadata.name`                      | string   | Override resource name from release          | nil                       |
| `dashboard.deployment.metadata.extraAnnotations`         | map      | Extra annotations to apply to resource       | {}                        |
| `dashboard.deployment.metadata.extraLabels`              | array    | Extra labels to apply to resource            | []                        |
| `dashboard.deployment.metadata.name`                     | string   | Override resource name from release          | nil                       |
| `dashboard.deployment.spec.replicas`                     | int      | Deployment replicas                          | 1                         |
| `dashboard.deployment.spec.revisionHistoryLimit`         | int      | Deployment revisionHistoryLimit              | 5                         |
| `dashboard.ingress.enabled`                              | bool     | Add Ingress resource                         | false                     |
| `dashboard.ingress.metadata.extraAnnotations`            | map      | Extra annotations to apply to resource       | {}                        |
| `dashboard.ingress.metadata.extraLabels`                 | array    | Extra labels to apply to resource            | []                        |
| `dashboard.ingress.metadata.name`                        | string   | Override resource name from release          | nil                       |
| `dashboard.ingress.spec.hosts`                           | array    | Ingress hosts                                | []                        |
| `dashboard.ingress.spec.tls`                             | array    | Ingress tls                                  | []                        |
| `dashboard.pods.metadata.extraAnnotations`               | map      | Extra annotations to apply to resource       | {}                        |
| `dashboard.pods.metadata.extraLabels`                    | array    | Extra labels to apply to resource            | []                        |
| `dashboard.pods.spec.affinity`                           | map      | Dashboard pods' affinity                     | {}                        |
| `dashboard.pods.spec.automountServiceAccountToken`       | bool     | Dashboard pods' automountServiceAccountToken | true                      |
| `dashboard.pods.spec.container.name`                     | string   | Dashboard container name                     | "kubetail"                |
| `dashboard.pods.spec.container.image.registry`           | string   | Registry to use for container image          | "kubetail/kubetail"       |
| `dashboard.pods.spec.container.image.tag`                | string   | Override chart app version                   | nil                       |
| `dashboard.pods.spec.container.imagePullPolicy`          | string   | Override default container imagePullPolicy   | nil                       |
| `dashboard.pods.spec.container.securityContext`          | map      | Dashboard container security context         | {}                        |
| `dashboard.pods.spec.container.containerPort`            | int      | Dashboard container containerPort            | 4000                      |
| `dashboard.pods.spec.container.args`                     | array    | Dashboard container args                     | *See values.yaml*         |
| `dashboard.pods.spec.container.extraEnv`                 | map      | Extra container env values                   | {}                        |
| `dashboard.pods.spec.container.extraEnvFrom`             | array    | Extra container envFrom values               | []                        |
| `dashboard.pods.spec.container.livenessProbe`            | map      | Dashboard container liveness probe           | *See values.yaml*         |
| `dashboard.pods.spec.container.readinessProbe`           | map      | Dashboard container readiness probe          | *See values.yaml*         |
| `dashboard.pods.spec.container.resources`                | map      | Dashboard container resources                | {}                        |
| `dashboard.pods.spec.nodeSelector`                       | map      | Dashboard pods' nodeSelector                 | {}                        |
| `dashboard.pods.spec.priorityClassName`                  | string   | Dashboard pods' priorityClassName            |                           |
| `dashboard.pods.spec.tolerations`                        | map      | Dashboard pods' tolerations                  |                           |
| `dashboard.secrets.opaque.enabled`                       | bool     | Add secret resource                          | true                      |
| `dashboard.secrets.opaque.metadata.extraAnnotations`     | map      | Extra annotations to apply to resource       | {}                        |
| `dashboard.secrets.opaque.metadata.extraLabels`          | array    | Extra labels to apply to resource            | []                        |
| `dashboard.secrets.opaque.metadata.name`                 | string   | Override resource name from release          | nil                       |
| `dashboard.secrets.opaque.data.KUBETAIL_CSRF_SECRET`     | string   | Override auto-generated value                | nil                       |
| `dashboard.secrets.opaque.data.KUBETAIL_SESSION_SECRET`  | string   | Override auto-generated value                | nil                       |
| `dashboard.service.metadata.extraAnnotations`            | map      | Extra annotations to apply to resource       | {}                        |
| `dashboard.service.metadata.extraLabels`                 | array    | Extra labels to apply to resource            | []                        |
| `dashboard.service.metadata.name`                        | string   | Override resource name from release          | nil                       |
| `dashboard.service.spec.port`                            | int      | Service port                                 |                           |
| `dashboard.service.spec.type`                            | string   | Service type                                 |                           |
| `dashboard.serviceAccount.automountServiceAccountToken`  | bool     | Value for `automountServiceAccountToken`     |                           |
| `dashboard.serviceAccount.metadata.extraAnnotations`     | map      | Extra annotations to apply to resource       | {}                        |
| `dashboard.serviceAccount.metadata.extraLabels`          | array    | Extra labels to apply to resource            | []                        |
| `dashboard.serviceAccount.metadata.name`                 | string   | Override resource name from release          | nil                       |
|                                                          |          |                                              |                           |
| AGENT:                                                   |          |                                              |                           |
| `agent.config`                                           | map      | Kubetail Agent config                        | *See values.yaml*         |
| `agent.clusterRole.metadata.extraAnnotations`            | map      | Extra annotations to apply to resource       | {}                        |
| `agent.clusterRole.metadata.extraLabels`                 | array    | Extra labels to apply to resource            | []                        |
| `agent.clusterRole.metadata.name`                        | string   | Override resource name from release          | nil                       |
| `agent.clusterRole.rules`                                | map      | Override ClusterRole rules                   |                           |
| `agent.clusterRoleBinding.metadata.extraAnnotations`     | map      | Extra annotations to apply to resource       | {}                        |
| `agent.clusterRoleBinding.metadata.extraLabels`          | array    | Extra labels to apply to resource            | []                        |
| `agent.clusterRoleBinding.metadata.name`                 | string   | Override resource name from release          | nil                       |
| `agent.configMap.metadata.extraAnnotations`              | map      | Extra annotations to apply to resource       | {}                        |
| `agent.configMap.metadata.extraLabels`                   | array    | Extra labels to apply to resource            | []                        |
| `agent.configMap.metadata.name`                          | string   | Override resource name from release          | nil                       |
| `agent.daemonset.metadata.extraAnnotations`              | map      | Extra annotations to apply to resource       | {}                        |
| `agent.daemonset.metadata.extraLabels`                   | array    | Extra labels to apply to resource            | []                        |
| `agent.daemonset.metadata.name`                          | string   | Override resource name from release          | nil                       |
| `agent.pods.metadata.extraAnnotations`                   | map      | Extra annotations to apply to resource       | {}                        |
| `agent.pods.metadata.extraLabels`                        | array    | Extra labels to apply to resource            | []                        |
| `agent.pods.spec.affinity`                               | map      | Agent pods' affinity                         |                           |
| `agent.pods.spec.automountServiceAccountToken`           | bool     | Agent pods' automountServiceAccountToken     |                           |
| `agent.pods.spec.container.name`                         | string   | Dashboard container name                     | "kubetail-agent"          |
| `agent.pods.spec.container.image.registry`               | string   | Registry to use for container image          | "kubetail/kubetail-agent" |
| `agent.pods.spec.container.image.tag`                    | string   | Override chart app version                   | nil                       |
| `agent.pods.spec.container.imagePullPolicy`              | string   | Override default container imagePullPolicy   | nil                       |
| `agent.pods.spec.container.securityContext`              | map      | Agent container security context             | {}                        |
| `agent.pods.spec.container.containerPort`                | int      | Agent container containerPort                | 4000                      |
| `agent.pods.spec.container.args`                         | array    | Agent container args                         | *See values.yaml*         |
| `agent.pods.spec.container.extraEnv`                     | map      | Extra container env values                   | {}                        |
| `agent.pods.spec.container.extraEnvFrom`                 | array    | Extra container envFrom values               | []                        |
| `agent.pods.spec.container.livenessProbe`                | map      | Agent container liveness probe               | *See values.yaml*         |
| `agent.pods.spec.container.readinessProbe`               | map      | Agent container readiness probe              | *See values.yaml*         |
| `agent.pods.spec.container.resources`                    | map      | Agent container resources                    |                           |
| `agent.pods.spec.nodeSelector`                           | map      | Agent pods' nodeSelector                     |                           |
| `agent.pods.spec.priorityClassName`                      | string   | Agent pods' priorityClassName                |                           |
| `agent.pods.spec.tolerations`                            | map      | Agent pods' tolerations                      |                           |
| `agent.secrets.opaque.enabled`                           | bool     | Add secret resource                          | true                      |
| `agent.secrets.opaque.metadata.extraAnnotations`         | map      | Extra annotations to apply to resource       | {}                        |
| `agent.secrets.opaque.metadata.extraLabels`              | array    | Extra labels to apply to resource            | []                        |
| `agent.secrets.opaque.metadata.name`                     | string   | Override resource name from release          | nil                       |
| `agent.secrets.opaque.data.KUBETAIL_TBD`                 | string   | Override auto-generated value                | nil                       |
| `agent.serviceAccount.automountServiceAccountToken`      | bool     | Value for `automountServiceAccountToken`     |                           |
| `agent.serviceAccount.metadata.extraAnnotations`         | map      | Extra annotations to apply to resource       | {}                        |
| `agent.serviceAccount.metadata.extraLabels`              | array    | Extra labels to apply to resource            | []                        |
| `agent.serviceAccount.metadata.name`                     | string   | Override resource name from release          | nil                       |
