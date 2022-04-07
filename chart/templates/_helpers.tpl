{{/*
Expand the name of the chart.
*/}}
{{- define "flink-state-analysis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "flink-state-analysis.fullname" -}}
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
{{- define "flink-state-analysis.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "flink-state-analysis.labels" -}}
helm.sh/chart: {{ include "flink-state-analysis.chart" . }}
{{ include "flink-state-analysis.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "flink-state-analysis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "flink-state-analysis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "flink-state-analysis.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "flink-state-analysis.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "flink-state-analysis.sourceTablePath" -}}
{{- printf "%s/%s/tables/%d" .Values.source.bucket .Values.source.baseDir  (.Values.workload.datasetSize | int) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "flink-state-analysis.sinkTablePath" -}}
{{- printf "%s/%s/results/%d" .Values.source.bucket .Values.source.baseDir (.Values.workload.datasetSize | int) | trunc 63 | trimSuffix "-" }}
{{- end }}
