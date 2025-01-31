#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright Contributors to the Egeria project.

echo "Waiting for the complete statefulset to be ready..."

REPLICA=0
while [ $REPLICA -lt $NUM_REPLICAS ]; do
  ENDPOINT="https://${XTDB_RELEASE_NAME}-xtdb-${REPLICA}.${INTERNAL_SVC_NAME}:9443"
  echo " ... checking availability of: ${ENDPOINT}"
  until curl -f -k -w "\n  (%{http_code} - %{url_effective})\n" --silent -X GET ${ENDPOINT}/open-metadata/admin-services/users/${EGERIA_USER}/servers/${XTDB_SERVER}/configuration; do
    echo " ... waiting another 10 seconds for ${ENDPOINT} to be in a running state."
    sleep 10
  done
  REPLICA=$(($REPLICA+1))
done

echo ""
