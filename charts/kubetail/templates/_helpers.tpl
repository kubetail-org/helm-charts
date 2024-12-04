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

{{/**************** Dashboard helpers ****************/}}

{{/*
Dashboard labels (including shared app labels)
*/}}
{{- define "kubetail.dashboard.labels" -}}
{{- $ctx := index . 0 -}}
{{- $labelSets := slice . 1 -}}
{{- $outputDict := dict -}}
{{- include "kubetail.addGlobalLabels" (list $ctx $outputDict) -}}
{{- $_ := set $outputDict "app.kubernetes.io/component" "dashboard" -}}
{{- range $labelSet := $labelSets -}}
{{- $outputDict = merge $labelSet $outputDict -}}
{{- end -}}
{{- include "kubetail.printDict" $outputDict -}}
{{- end -}}

{{/*
Dashboard selector labels
*/}}
{{- define "kubetail.dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubetail.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/component: "dashboard"
{{- end }}

{{/*
Dashboard config
*/}}
{{- define "kubetail.dashboard.config" -}}
auth-mode: {{ .Values.kubetail.authMode }}
{{- with .Values.kubetail.allowedNamespaces }}
allowed-namespaces: 
{{- toYaml . | nindent 0 }}
{{- end }}
dashboard:
  addr: :{{ .Values.kubetail.dashboard.runtimeConfig.port }}
  extensions-enabled: {{ .Values.kubetail.api.enabled }}
  {{- $cfg := omit .Values.kubetail.dashboard.runtimeConfig "port" }}
  {{- $_ := set $cfg.csrf "secret" "${KUBETAIL_DASHBOARD_CSRF_SECRET}" }}
  {{- $_ := set $cfg.session "secret" "${KUBETAIL_DASHBOARD_SESSION_SECRET}" }}
  {{- include "kubetail.toKebabYaml" $cfg | nindent 2 }}
{{- end }}

{{/*
Dashboard image
*/}}
{{- define "kubetail.dashboard.image" -}}
{{- $img := .Values.kubetail.dashboard.image -}}
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
Dashboard ClusterRole name
*/}}
{{- define "kubetail.dashboard.clusterRoleName" -}}
{{ if .Values.kubetail.dashboard.rbac.name }}{{ .Values.kubetail.dashboard.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-dashboard{{ end }}
{{- end }}

{{/*
Dashboard ClusterRoleBinding name
*/}}
{{- define "kubetail.dashboard.clusterRoleBindingName" -}}
{{ if .Values.kubetail.dashboard.rbac.name }}{{ .Values.kubetail.dashboard.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-dashboard{{ end }}
{{- end }}

{{/*
Dashboard ConfigMap name
*/}}
{{- define "kubetail.dashboard.configMapName" -}}
{{ default (include "kubetail.fullname" .) .Values.kubetail.dashboard.configMap.name }}-dashboard
{{- end }}

{{/*
Dashboard Deployment name
*/}}
{{- define "kubetail.dashboard.deploymentName" -}}
{{ if .Values.kubetail.dashboard.deployment.name }}{{ .Values.kubetail.dashboard.deployment.name }}{{ else }}{{ include "kubetail.fullname" . }}-dashboard{{ end }}
{{- end }}

{{/*
Dashboard ingress name
*/}}
{{- define "kubetail.dashboard.ingressName" -}}
{{ default (include "kubetail.fullname" .) .Values.kubetail.dashboard.ingress.name }}-dashboard
{{- end }}

{{/*
Dashboard Role name
*/}}
{{- define "kubetail.dashboard.roleName" -}}
{{ if .Values.kubetail.dashboard.rbac.name }}{{ .Values.kubetail.dashboard.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-dashboard{{ end }}
{{- end }}

{{/*
Dashboard RoleBinding name
*/}}
{{- define "kubetail.dashboard.roleBindingName" -}}
{{ if .Values.kubetail.dashboard.rbac.name }}{{ .Values.kubetail.dashboard.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-dashboard{{ end }}
{{- end }}

{{/*
Dashboard Secret name
*/}}
{{- define "kubetail.dashboard.secretName" -}}
{{ if .Values.kubetail.dashboard.secret.name }}{{ .Values.kubetail.dashboard.secret.name }}{{ else }}{{ include "kubetail.fullname" . }}-dashboard{{ end }}
{{- end }}

{{/*
Dashboard Secret data
*/}}
{{- define "kubetail.dashboard.secretData" -}}
{{- $currentValsRef := dict "data" dict -}}
{{- $currentResource := (lookup "v1" "Secret" (include "kubetail.namespace" .) (include "kubetail.dashboard.secretName" .)) -}}
{{- if $currentResource -}}
{{- $_ := set $currentValsRef "data" (index $currentResource "data") -}}
{{- end -}}
KUBETAIL_DASHBOARD_CSRF_SECRET: {{ .Values.kubetail.secrets.KUBETAIL_DASHBOARD_CSRF_SECRET | default $currentValsRef.data.KUBETAIL_DASHBOARD_CSRF_SECRET | default ((randAlphaNum 32) | b64enc | quote) }}
KUBETAIL_DASHBOARD_SESSION_SECRET: {{ .Values.kubetail.secrets.KUBETAIL_DASHBOARD_SESSION_SECRET | default $currentValsRef.data.KUBETAIL_DASHBOARD_SESSION_SECRET | default ((randAlphaNum 32) | b64enc | quote) }}
{{- end }}

{{/*
Dashboard Service name
*/}}
{{- define "kubetail.dashboard.serviceName" -}}
{{ if .Values.kubetail.dashboard.service.name }}{{ .Values.kubetail.dashboard.service.name }}{{ else }}{{ include "kubetail.fullname" . }}-dashboard{{ end }}
{{- end }}

{{/*
Dashboard ServiceAccount name
*/}}
{{- define "kubetail.dashboard.serviceAccountName" -}}
{{ if .Values.kubetail.dashboard.serviceAccount.name }}{{ .Values.kubetail.dashboard.serviceAccount.name }}{{ else }}{{ include "kubetail.fullname" . }}-dashboard{{ end }}
{{- end }}

{{/**************** API helpers ****************/}}

{{/*
API labels (including shared app labels)
*/}}
{{- define "kubetail.api.labels" -}}
{{- $ctx := index . 0 -}}
{{- $labelSets := slice . 1 -}}
{{- $outputDict := dict -}}
{{- include "kubetail.addGlobalLabels" (list $ctx $outputDict) -}}
{{- $_ := set $outputDict "app.kubernetes.io/component" "api" -}}
{{- range $labelSet := $labelSets -}}
{{- $outputDict = merge $labelSet $outputDict -}}
{{- end -}}
{{- include "kubetail.printDict" $outputDict -}}
{{- end -}}

{{/*
API selector labels
*/}}
{{- define "kubetail.api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubetail.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/component: "api"
{{- end }}

{{/*
API config
*/}}
{{- define "kubetail.api.config" -}}
auth-mode: {{ .Values.kubetail.authMode }}
{{- with .Values.kubetail.allowedNamespaces }}
allowed-namespaces: 
{{- toYaml . | nindent 0 }}
{{- end }}
api:
  addr: :{{ .Values.kubetail.api.runtimeConfig.ports.grpc }}
  agent-dispatch-url: "kubernetes://{{ include "kubetail.agent.serviceName" . }}:{{ .Values.kubetail.agent.runtimeConfig.port }}"
  {{- $cfg := omit .Values.kubetail.api.runtimeConfig "ports" "grpc" }}
  {{- include "kubetail.toKebabYaml" $cfg | nindent 2 }}
{{- end }}

{{/*
API image
*/}}
{{- define "kubetail.api.image" -}}
{{- $img := .Values.kubetail.api.image -}}
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
API ConfigMap name
*/}}
{{- define "kubetail.api.configMapName" -}}
{{ default (include "kubetail.fullname" .) .Values.kubetail.api.configMap.name }}-api
{{- end }}

{{/*
API Deployment name
*/}}
{{- define "kubetail.api.deploymentName" -}}
{{ if .Values.kubetail.api.deployment.name }}{{ .Values.kubetail.api.deployment.name }}{{ else }}{{ include "kubetail.fullname" . }}-api{{ end }}
{{- end }}

{{/*
API Role name
*/}}
{{- define "kubetail.api.roleName" -}}
{{ if .Values.kubetail.api.rbac.name }}{{ .Values.kubetail.api.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-api{{ end }}
{{- end }}

{{/*
API RoleBinding name
*/}}
{{- define "kubetail.api.roleBindingName" -}}
{{ if .Values.kubetail.api.rbac.name }}{{ .Values.kubetail.api.rbac.name }}{{ else }}{{ include "kubetail.fullname" . }}-api{{ end }}
{{- end }}

{{/*
API Service name
*/}}
{{- define "kubetail.api.serviceName" -}}
{{ if .Values.kubetail.api.service.name }}{{ .Values.kubetail.api.service.name }}{{ else }}{{ include "kubetail.fullname" . }}-api{{ end }}
{{- end }}

{{/*
API ServiceAccount name
*/}}
{{- define "kubetail.api.serviceAccountName" -}}
{{ if .Values.kubetail.api.serviceAccount.name }}{{ .Values.kubetail.api.serviceAccount.name }}{{ else }}{{ include "kubetail.fullname" . }}-api{{ end }}
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
