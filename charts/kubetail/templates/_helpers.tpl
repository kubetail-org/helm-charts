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
Print the namespace for the metadata section
*/}}
{{- define "kubetail.metadataNamespace" -}}
namespace: {{ include "kubetail.namespace" . }}
{{- end }}

{{/*
Kubetail selector labels
*/}}
{{- define "kubetail.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubetail.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Kubetail labels
*/}}
{{- define "kubetail.labels" -}}
{{- with .Values.labels -}}
{{ toYaml . }}
{{ end -}}
helm.sh/chart: {{ include "kubetail.chart" . }}
{{ include "kubetail.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
ServiceAccount name
*/}}
{{- define "kubetail.serviceAccountName" -}}
{{ if .Values.serviceAccount.name }}{{ .Values.serviceAccount.name }}{{ else }}{{ include "kubetail.fullname" . }}{{ end }}
{{- end }}
