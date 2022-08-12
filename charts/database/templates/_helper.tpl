{{- define "database.envs" }}
env:
- name: DATABASE_STORAGE
  value: "{{.Values.global.storage}}"
{{- if eq .Values.debug "true" }}
- name: PATRONI_LOG_LEVEL
  value: DEBUG
- name: PATRONI_LOG_TRACEBACK_LEVEL
  value: DEBUG
{{- end }}
- name: PGCTLTIMEOUT
  value: "{{.Values.timeout}}"
- name: PATRONI_KUBERNETES_POD_IP
  valueFrom:
    fieldRef:
      fieldPath: status.podIP
- name: PATRONI_KUBERNETES_NAMESPACE
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
- name: PATRONI_KUBERNETES_BYPASS_API_SERVICE
  value: 'true'
- name: PATRONI_KUBERNETES_USE_ENDPOINTS
  value: 'true'
- name: PATRONI_KUBERNETES_LABELS
  value: '{app: drycc-database, cluster-name: drycc-database}'
- name: PATRONI_SCOPE
  value: drycc-database
- name: PATRONI_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
- name: PATRONI_POSTGRESQL_PGPASS
  value: /tmp/pgpass
- name: PATRONI_POSTGRESQL_LISTEN
  value: '0.0.0.0:5432'
- name: PATRONI_RESTAPI_LISTEN
  value: '0.0.0.0:8008'
- name: DRYCC_DATABASE_SUPERUSER
  valueFrom:
    secretKeyRef:
      name: database-creds
      key: superuser
- name: DRYCC_DATABASE_SUPERUSER_PASSWORD
  valueFrom:
    secretKeyRef:
      name: database-creds
      key: superuser-password
- name: DRYCC_DATABASE_REPLICATOR
  valueFrom:
    secretKeyRef:
      name: database-creds
      key: replicator
- name: DRYCC_DATABASE_REPLICATOR_PASSWORD
  valueFrom:
    secretKeyRef:
      name: database-creds
      key: replicator-password
- name: "DRYCC_DATABASE_USER"
  valueFrom:
    secretKeyRef:
      name: database-creds
      key: user
- name: "DRYCC_DATABASE_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: database-creds
      key: password
{{- if eq .Values.global.storageLocation "on-cluster" }}
- name: "DRYCC_STORAGE_HEALTH"
  valueFrom:
    secretKeyRef:
      name: storage-creds
      key: health
{{- end }}
{{- end }}

{{/* Generate database deployment limits */}}
{{- define "database.limits" -}}
{{- if or (.Values.limitsCpu) (.Values.limitsMemory)}}
resources:
  limits:
    {{- if (.Values.limitsCpu) }}
    cpu: {{.Values.limitsCpu}}
    {{- end }}
    {{- if (.Values.limitsMemory) }}
    memory: {{.Values.limitsMemory}}
    {{- end }}
    {{- if (.Values.limitsHugepages2Mi) }}
    hugepages-2Mi: {{.Values.limitsHugepages2Mi}}
    {{- end }}
    {{- if (.Values.limitsHugepages1Gi) }}
    hugepages-1Gi: {{.Values.limitsHugepages1Gi}}
    {{- end }}
{{- end }}
{{- end }}
