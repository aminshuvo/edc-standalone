{{/*
Expand the name of the chart.
*/}}
{{- define "edc-standalone.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "edc-standalone.fullname" -}}
{{- if .Values.global.fullnameOverride }}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.global.nameOverride }}
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
{{- define "edc-standalone.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "edc-standalone.labels" -}}
helm.sh/chart: {{ include "edc-standalone.chart" . }}
{{ include "edc-standalone.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "edc-standalone.selectorLabels" -}}
app.kubernetes.io/name: {{ include "edc-standalone.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "edc-standalone.serviceAccountName" -}}
{{- if .Values.serviceAccounts.create }}
{{- default (include "edc-standalone.fullname" .) .Values.serviceAccounts.name }}
{{- else }}
{{- default "default" .Values.serviceAccounts.name }}
{{- end }}
{{- end }}

{{/*
EDC Standalone specific helpers
*/}}
{{- define "edc-standalone.standalone.fullname" -}}
{{- printf "%s-standalone" (include "edc-standalone.fullname" .) }}
{{- end }}

{{- define "edc-standalone.standalone.labels" -}}
{{ include "edc-standalone.labels" . }}
component: edc-standalone
{{- end }}

{{- define "edc-standalone.standalone.selectorLabels" -}}
{{ include "edc-standalone.selectorLabels" . }}
component: edc-standalone
{{- end }}

{{/*
EDC Peer specific helpers
*/}}
{{- define "edc-standalone.peer.fullname" -}}
{{- printf "%s-peer" (include "edc-standalone.fullname" .) }}
{{- end }}

{{- define "edc-standalone.peer.labels" -}}
{{ include "edc-standalone.labels" . }}
component: edc-peer
{{- end }}

{{- define "edc-standalone.peer.selectorLabels" -}}
{{ include "edc-standalone.selectorLabels" . }}
component: edc-peer
{{- end }}

{{/*
Monitoring specific helpers
*/}}
{{- define "edc-standalone.monitoring.fullname" -}}
{{- printf "%s-monitoring" (include "edc-standalone.fullname" .) }}
{{- end }}

{{- define "edc-standalone.monitoring.labels" -}}
{{ include "edc-standalone.labels" . }}
component: monitoring
{{- end }}

{{/*
Generate configuration properties for EDC
*/}}
{{- define "edc-standalone.config.properties" -}}
{{- $config := . -}}
# EDC Configuration Properties
edc.connector.name={{ $config.connector.name }}
edc.connector.id={{ $config.connector.id }}

{{- if $config.web }}
# Web Server Configuration
edc.web.http.port={{ $config.web.http.port }}
edc.web.http.data.port={{ $config.web.http.data.port }}
edc.web.http.management.port={{ $config.web.http.management.port }}
edc.web.http.management.path={{ $config.web.http.management.path }}
{{- end }}

# Control Plane Configuration
edc.controlplane.endpoint.url={{ $config.controlplane.endpoint.url }}
edc.controlplane.endpoint.port={{ $config.controlplane.endpoint.port }}

# Data Plane Configuration
edc.dataplane.endpoint.url={{ $config.dataplane.endpoint.url }}
edc.dataplane.endpoint.port={{ $config.dataplane.endpoint.port }}

# Storage Configuration
edc.storage.type={{ $config.storage.type }}

# Authentication Configuration
edc.auth.type={{ $config.auth.type }}

# Policy Configuration
edc.policy.engine.type={{ $config.policy.engine.type }}

# Transfer Configuration
edc.transfer.type={{ $config.transfer.type }}
edc.transfer.endpoint.url={{ $config.transfer.endpoint.url }}
edc.transfer.proxy.token.signer.privatekey.alias={{ $config.transfer.proxy.token.signer.privatekey.alias }}
edc.transfer.proxy.token.verifier.publickey.alias={{ $config.transfer.proxy.token.verifier.publickey.alias }}

# Catalog Configuration
edc.catalog.endpoint.url={{ $config.catalog.endpoint.url }}

# IAM Configuration
edc.iam.issuer.id={{ $config.iam.issuer.id }}
edc.iam.sts.oauth.token.url={{ $config.iam.sts.oauth.token.url }}
edc.iam.sts.oauth.client.id={{ $config.iam.sts.oauth.client.id }}
{{- if $config.iam.sts.oauth.client.secret.alias }}
edc.iam.sts.oauth.client.secret.alias={{ $config.iam.sts.oauth.client.secret.alias }}
{{- end }}

{{- if $config.peer }}
# Peer Integration Configuration
edc.peer.standalone.url={{ $config.peer.standalone.url }}
edc.peer.standalone.id={{ $config.peer.standalone.id }}
{{- end }}

{{- if $config.tx }}
# Additional Configuration
tx.iam.iatp.bdrs.server.url={{ $config.tx.iam.iatp.bdrs.server.url }}
{{- end }}
{{- end }} 