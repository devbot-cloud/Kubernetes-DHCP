{{/*
Expand the name of the chart.
*/}}
{{- define "dhcp-k8s.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dhcp-k8s.fullname" -}}
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
{{- define "dhcp-k8s.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dhcp-k8s.labels" -}}
helm.sh/chart: {{ include "dhcp-k8s.chart" . }}
{{ include "dhcp-k8s.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dhcp-k8s.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dhcp-k8s.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dhcp-k8s.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dhcp-k8s.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Using the Fully qualified name Generate the name of the primary DHCP instance.
*/}}
{{- define "dhcp-k8s.primaryname" -}}
{{- printf "%s-%s" (include "dhcp-k8s.fullname" .) "primary" }}
{{- end }}

{{/*
Primary labels
*/}}
{{- define "dhcp-k8s.primarylabels" -}}
dhcp-server/role: primary
{{- end }}


{{/*
Primary Volumes:
- Construct the list of volumes that will be attached to the primary DHCP container 
- Making it easier in the primary yaml

- 1,) check if the PVC is enabled 
    - if so mount it 
    - if not mount an emptyDir volume
*/}}
{{- define "dhcp-k8s.primaryvolumes" -}}
- name: leases
{{- if .Values.pvc.enabled }}
  persistentVolumeClaim:
    claimName: {{ include "dhcp-k8s.primaryname" .}}
{{- else }}
  emptyDir: {}
{{- end }}
- name: config
  configMap:
    name: {{ include "dhcp-k8s.primaryname" . }}
{{- with .Values.volumes }}
{{- toYaml .}}
{{- end }}
{{- end -}}