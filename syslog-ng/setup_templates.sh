#!/usr/bin/env bash
curl -sS -X PUT "http://127.0.0.1:9200/_index_template/logs-template" \
  -H 'Content-Type: application/json' \
  --data-binary @logs-template.json
