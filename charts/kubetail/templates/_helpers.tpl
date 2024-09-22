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
Kubetail shared app labels
*/}}
{{- define "kubetail.labels" -}}
helm.sh/chart: {{ include "kubetail.chart" . }}
app.kubernetes.io/name: {{ include "kubetail.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Kubetail shared app attributes
*/}}
{{- define "kubetail.attributes" -}}
{{- with .Values.kubetail.global.attributes }}
{{- toYaml . }}
{{- end -}}
{{- end }}

{{/**************** Global helpers ****************/}}

{{/*
Global labels
*/}}
{{- define "kubetail.global.labels" -}}
{{- with .Values.kubetail.global.labels }}
{{- toYaml . }}
{{- end }}
{{- end }}


{{/**************** Server helpers ****************/}}

{{/*
Server labels (including shared app labels)
*/}}
{{- define "kubetail.server.labels" -}}
{{ include "kubetail.labels" . }}
app.kubernetes.io/component: server
{{- end }}

{{/*
Server selector labels
*/}}
{{- define "kubetail.server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubetail.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: server
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
  {{- $cfg := omit .Values.kubetail.server.runtimeConfig "port" }}
  {{- $_ := set $cfg.csrf "secret" "${KUBETAIL_SERVER_CSRF_SECRET}" }}
  {{- $_ := set $cfg.session "secret" "${KUBETAIL_SERVER_SESSION_SECRET}" }}
  {{- toYaml $cfg | nindent 2 }}
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
{{ if .Values.kubetail.server.clusterRole.name }}{{ .Values.kubetail.server.clusterRole.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
{{- end }}

{{/*
Server ClusterRoleBinding name
*/}}
{{- define "kubetail.server.clusterRoleBindingName" -}}
{{ if .Values.kubetail.server.clusterRoleBinding.name }}{{ .Values.kubetail.server.clusterRoleBinding.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
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
Server Role name
*/}}
{{- define "kubetail.server.roleName" -}}
{{ if .Values.kubetail.server.role.name }}{{ .Values.kubetail.server.role.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
{{- end }}

{{/*
Server RoleBinding name
*/}}
{{- define "kubetail.server.roleBindingName" -}}
{{ if .Values.kubetail.server.roleBinding.name }}{{ .Values.kubetail.server.roleBinding.name }}{{ else }}{{ include "kubetail.fullname" . }}-server{{ end }}
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
{{ include "kubetail.labels" . }}
app.kubernetes.io/component: agent
{{- end }}

{{/*
Agent selector labels
*/}}
{{- define "kubetail.agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubetail.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: agent
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
  {{- toYaml $cfg | nindent 2 }}
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
{{ if .Values.kubetail.agent.clusterRole.name }}{{ .Values.kubetail.agent.clusterRole.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
{{- end }}

{{/*
Agent ClusterRoleBinding name
*/}}
{{- define "kubetail.agent.clusterRoleBindingName" -}}
{{ if .Values.kubetail.agent.clusterRoleBinding.name }}{{ .Values.kubetail.agent.clusterRoleBinding.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
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
{{ if .Values.kubetail.agent.role.name }}{{ .Values.kubetail.agent.role.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
{{- end }}

{{/*
Agent RoleBinding name
*/}}
{{- define "kubetail.agent.roleBindingName" -}}
{{ if .Values.kubetail.agent.roleBinding.name }}{{ .Values.kubetail.agent.roleBinding.name }}{{ else }}{{ include "kubetail.fullname" . }}-agent{{ end }}
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
