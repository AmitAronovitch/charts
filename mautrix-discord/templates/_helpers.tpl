{{/*
Expand the name of the chart.
*/}}
{{- define "mautrix-discord.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mautrix-discord.fullname" -}}
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
{{- define "mautrix-discord.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mautrix-discord.labels" -}}
helm.sh/chart: {{ include "mautrix-discord.chart" . }}
{{ include "mautrix-discord.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mautrix-discord.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mautrix-discord.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mautrix-discord.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mautrix-discord.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the correct image tag name
*/}}
{{- define "mautrix-discord.imageTag" -}}
{{- .Values.image.tag | default (printf "v%s" .Chart.AppVersion) -}}
{{- end }}

{{/*
The address that the homeserver can use to connect to this appservice
*/}}
{{- define "mautrix-discord.serviceurl" -}}
{{- .Values.appservice.address | default (printf "http://%s:%d" (include "mautrix-discord.fullname" .) (int .Values.service.port) ) -}}
{{- end }}
