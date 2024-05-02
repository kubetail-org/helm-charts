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

{{/*
Kubetail selector labels
*/}}
{{- define "kubetail.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubetail.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Kubetail shared labels
*/}}
{{- define "kubetail.labels" -}}
helm.sh/chart: {{ include "kubetail.chart" . }}
{{ include "kubetail.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Kubetail image
*/}}
{{- define "kubetail.image" -}}
{{- $img := .Values.kubetail.image -}}
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
ClusterRole name
*/}}
{{- define "kubetail.clusterRoleName" -}}
{{ if .Values.kubetail.clusterRole.name }}{{ .Values.kubetail.clusterRole.name }}{{ else }}{{ include "kubetail.fullname" . }}{{ end }}
{{- end }}

{{/*
ConfigMap name
*/}}
{{- define "kubetail.configMapName" -}}
{{ default (include "kubetail.fullname" .) .Values.kubetail.configMap.name }}
{{- end }}

{{/*
ServiceAccount name
*/}}
{{- define "kubetail.serviceAccountName" -}}
{{ if .Values.kubetail.serviceAccount.name }}{{ .Values.kubetail.serviceAccount.name }}{{ else }}{{ include "kubetail.fullname" . }}{{ end }}
{{- end }}

{{/*
Secret name
*/}}
{{- define "kubetail.secretName" -}}
{{ if .Values.kubetail.secret.name }}{{ .Values.kubetail.secret.name }}{{ else }}{{ include "kubetail.fullname" . }}{{ end }}
{{- end }}

{{/*
Kubetail config
*/}}
{{- define "kubetail.config" -}}
addr: :{{ .Values.kubetail.podTemplate.port }}
auth-mode: {{ .Values.kubetail.authMode }}
{{- with .Values.kubetail.config }}
{{- tpl . $ | nindent 0 }}
{{- end }}
{{- end }}
