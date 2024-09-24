{{/*
Expand the name of the chart.
*/}}
{{- define "kubetail.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubetail.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kubetail.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Print the namespace
*/}}
{{- define "kubetail.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride }}
{{- end }}

{{/**************** Shared helpers ****************/}}

{{/*
Print key/value quoted pairs
*/}}
{{- define "kubetail.printDict" -}}
{{- if . -}}
{{- range $key, $value := . }}
{{ $key }}: {{ $value | quote }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Add global labels to input dict
*/}}
{{- define "kubetail.addGlobalLabels" -}}
{{- $ctx := index . 0 -}}
{{- $inputDict := index . 1 -}}
{{- $_ := set $inputDict "helm.sh/chart" (include "kubetail.chart" $ctx) -}}
{{- $_ := set $inputDict "app.kubernetes.io/name" (include "kubetail.name" $ctx) -}}
{{- $_ := set $inputDict "app.kubernetes.io/version" $ctx.Chart.AppVersion -}}
{{- $_ := set $inputDict "app.kubernetes.io/instance" $ctx.Release.Name -}}
{{- $_ := set $inputDict "app.kubernetes.io/managed-by" $ctx.Release.Service -}}
{{- $inputDict = merge $ctx.Values.kubetail.global.labels $inputDict -}}
{{- end -}}

{{/*
Print annotations
*/}}
{{- define "kubetail.annotations" -}}
{{- $ctx := index . 0 -}}
{{- $annotationSet := index . 1 -}}
{{- $annotations := (merge $annotationSet $ctx.Values.kubetail.global.annotations) -}}
{{- include "kubetail.printDict" $annotations -}}
{{- end -}}

{{/*
Convert YAML keys to kebab-case
*/}}
{{- define "kubetail.toKebabYaml" -}}
{{- $result := dict -}}
{{- range $key, $value := . -}}
  {{- $newKey := $key | kebabcase -}}
  {{- if kindIs "map" $value -}}
    {{- $newValue := include "kubetail.toKebabYaml" $value | fromYaml -}}
    {{- $_ := set $result $newKey $newValue -}}
  {{- else if kindIs "slice" $value -}}
    {{- $newValue := list -}}
    {{- range $item := $value -}}
      {{- if kindIs "map" $item -}}
        {{- $convertedItem := include "kubetail.toKebabYaml" $item | fromYaml -}}
        {{- $newValue = append $newValue $convertedItem -}}
      {{- else -}}
        {{- $newValue = append $newValue $item -}}
      {{- end -}}
    {{- end -}}
    {{- $_ := set $result $newKey $newValue -}}
  {{- else -}}
    {{- $_ := set $result $newKey $value -}}
  {{- end -}}
{{- end -}}
{{- $result | toYaml -}}
{{- end -}}

{{/**************** Server helpers ****************/}}

{{/*
Server labels (including shared app labels)
*/}}
{{- define "kubetail.server.labels" -}}
{{- $ctx := index . 0 -}}
{{- $labelSets := slice . 1 -}}
{{- $outputDict := dict -}}
{{- include "kubetail.addGlobalLabels" (list $ctx $outputDict) -}}
{{- $_ := set $outputDict "app.kubernetes.io/component" "server" -}}
{{- range $labelSet := $labelSets -}}
{{- $outputDict = merge $labelSet $outputDict -}}
{{- end -}}
{{- include "kubetail.printDict" $outputDict -}}
{{- end -}}

{{/*
Server selector labels
*/}}
{{- define "kubetail.server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubetail.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/component: "server"
{{- end }}

{{/*
Server config
*/}}
{{- define "kubetail.server.config" -}}
auth-mode: {{ .Values.kubetail.authMode }}
{{- with .Values.kubetail.allowedNamespaces }}
allowed-namespaces: 
{{- toYaml . | nindent 0 }}
{{- end }}
server:
  addr: :{{ .Values.kubetail.server.runtimeConfig.port }}
  agent-dispatch-url: "kubernetes://{{ include "kubetail.agent.serviceName" . }}:{{ .Values.kubetail.agent.runtimeConfig.port }}"
  {{- $cfg := omit .Values.kubetail.server.runtimeConfig "port" }}
  {{- $_ := set $cfg.csrf "secret" "${KUBETAIL_SERVER_CSRF_SECRET}" }}
  {{- $_ := set $cfg.session "secret" "${KUBETAIL_SERVER_SESSION_SECRET}" }}
  {{- include "kubetail.toKebabYaml" $cfg | nindent 2 }}
{{- end }}

{{/*
Server image
*/}}
{{- define "kubetail.server.image" -}}
{{- $img := .Values.kubetail.server.image -}}
{{- $registry := $img.registry | default "" -}}
{{- $repository := $img.repository | default "" -}}
{{- $ref := ternary (printf ":%s" ($img.tag | default .Chart.AppVersion | toString)) (printf "@%s" $img.digest) (empty $img.digest) -}}
{{- if and $registry $repository -}}
  {{- printf "%s/%s%s" $registry $repository $ref -}}
{{- else -}}
  {{- printf "%s%s%s" $registry $repository $ref -}}
{{- end -}}
{{- end }}

{{/*
Server ClusterRole name
*/}}
{{- define "kubetail.server.clusterRoleName" -}}
{{ if .Values.kubetail.server.rbac.name }}{{ .Values.kubetail.server.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
{{- end }}

{{/*
Server ClusterRoleBinding name
*/}}
{{- define "kubetail.server.clusterRoleBindingName" -}}
{{ if .Values.kubetail.server.rbac.name }}{{ .Values.kubetail.server.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
{{- end }}

{{/*
Server ConfigMap name
*/}}
{{- define "kubetail.server.configMapName" -}}
{{ default (include "kubetail.fullname" .) .Values.kubetail.server.configMap.name }}-server
{{- end }}

{{/*
Server Deployment name
*/}}
{{- define "kubetail.server.deploymentName" -}}
{{ if .Values.kubetail.server.deployment.name }}{{ .Values.kubetail.server.deployment.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
{{- end }}

{{/*
Server ingress name
*/}}
{{- define "kubetail.server.ingressName" -}}
{{ default (include "kubetail.fullname" .) .Values.kubetail.server.ingress.name }}-server
{{- end }}

{{/*
Server Role name
*/}}
{{- define "kubetail.server.roleName" -}}
{{ if .Values.kubetail.server.rbac.name }}{{ .Values.kubetail.server.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
{{- end }}

{{/*
Server RoleBinding name
*/}}
{{- define "kubetail.server.roleBindingName" -}}
{{ if .Values.kubetail.server.rbac.name }}{{ .Values.kubetail.server.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
{{- end }}

{{/*
Server Secret name
*/}}
{{- define "kubetail.server.secretName" -}}
{{ if .Values.kubetail.server.secret.name }}{{ .Values.kubetail.server.secret.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
{{- end }}

{{/*
Server Service name
*/}}
{{- define "kubetail.server.serviceName" -}}
{{ if .Values.kubetail.server.service.name }}{{ .Values.kubetail.server.service.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
{{- end }}

{{/*
Server ServiceAccount name
*/}}
{{- define "kubetail.server.serviceAccountName" -}}
{{ if .Values.kubetail.server.serviceAccount.name }}{{ .Values.kubetail.server.serviceAccount.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
{{- end }}

{{/**************** Agent helpers ****************/}}

{{/*
Agent labels (including shared app labels)
*/}}
{{- define "kubetail.agent.labels" -}}
{{- $ctx := index . 0 -}}
{{- $labelSets := slice . 1 -}}
{{- $outputDict := dict -}}
{{- include "kubetail.addGlobalLabels" (list $ctx $outputDict) -}}
{{- $_ := set $outputDict "app.kubernetes.io/component" "agent" -}}
{{- range $labelSet := $labelSets -}}
{{- $outputDict = merge $labelSet $outputDict -}}
{{- end -}}
{{- include "kubetail.printDict" $outputDict -}}
{{- end -}}

{{/*
Agent selector labels
*/}}
{{- define "kubetail.agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubetail.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/component: "agent"
{{- end }}

{{/*
Agent config
*/}}
{{- define "kubetail.agent.config" -}}
auth-mode: {{ .Values.kubetail.authMode }}
{{- with .Values.kubetail.allowedNamespaces }}
allowed-namespaces: 
{{- toYaml . | nindent 0 }}
{{- end }}
agent:
  addr: :{{ .Values.kubetail.agent.runtimeConfig.port }}
  {{- $cfg := omit .Values.kubetail.agent.runtimeConfig "port" }}
  {{- include "kubetail.toKebabYaml" $cfg | nindent 2 }}
{{- end }}

{{/*
Agent image
*/}}
{{- define "kubetail.agent.image" -}}
{{- $img := .Values.kubetail.agent.image -}}
{{- $registry := $img.registry | default "" -}}
{{- $repository := $img.repository | default "" -}}
{{- $ref := ternary (printf ":%s" ($img.tag | default .Chart.AppVersion | toString)) (printf "@%s" $img.digest) (empty $img.digest) -}}
{{- if and $registry $repository -}}
  {{- printf "%s/%s%s" $registry $repository $ref -}}
{{- else -}}
  {{- printf "%s%s%s" $registry $repository $ref -}}
{{- end -}}
{{- end }}

{{/*
Agent ClusterRole name
*/}}
{{- define "kubetail.agent.clusterRoleName" -}}
{{ if .Values.kubetail.agent.rbac.name }}{{ .Values.kubetail.agent.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
{{- end }}

{{/*
Agent ClusterRoleBinding name
*/}}
{{- define "kubetail.agent.clusterRoleBindingName" -}}
{{ if .Values.kubetail.agent.rbac.name }}{{ .Values.kubetail.agent.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
{{- end }}

{{/*
Agent ConfigMap name
*/}}
{{- define "kubetail.agent.configMapName" -}}
{{ default (include "kubetail.fullname" .) .Values.kubetail.agent.configMap.name }}-agent
{{- end }}

{{/*
Agent DaemonSet name
*/}}
{{- define "kubetail.agent.daemonSetName" -}}
{{ if .Values.kubetail.agent.daemonSet.name }}{{ .Values.kubetail.agent.daemonSet.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
{{- end }}

{{/*
Agent NetworkPolicy name
*/}}
{{- define "kubetail.agent.networkPolicyName" -}}
{{ if .Values.kubetail.agent.networkPolicy.name }}{{ .Values.kubetail.agent.networkPolicy.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
{{- end }}

{{/*
Agent Role name
*/}}
{{- define "kubetail.agent.roleName" -}}
{{ if .Values.kubetail.agent.rbac.name }}{{ .Values.kubetail.agent.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
{{- end }}

{{/*
Agent RoleBinding name
*/}}
{{- define "kubetail.agent.roleBindingName" -}}
{{ if .Values.kubetail.agent.rbac.name }}{{ .Values.kubetail.agent.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
{{- end }}

{{/*
Agent Service name
*/}}
{{- define "kubetail.agent.serviceName" -}}
{{ if .Values.kubetail.agent.service.name }}{{ .Values.kubetail.agent.service.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
{{- end }}

{{/*
Agent ServiceAccount name
*/}}
{{- define "kubetail.agent.serviceAccountName" -}}
{{ if .Values.kubetail.agent.serviceAccount.name }}{{ .Values.kubetail.agent.serviceAccount.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
{{- end }}
