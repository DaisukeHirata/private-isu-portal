#!/bin/bash -eu

TEAM_NAME="xxxxxx"       # team name
TARGET_IP="xx.xx.xx.xx"  # ip address of competition instance
PORTAL_HOST="xxxxxx.firebaseio.com" # Firebase Realtime DB hostname

BENCHMARKER="/opt/go/bin/benchmarker"
USERDATA_DIR="/opt/go/src/github.com/catatsuy/private-isu/benchmarker/userdata"

RESULT=`${BENCHMARKER} -t http://${TARGET_IP}/ -u ${USERDATA_DIR}`

echo ${RESULT} | jq '.'

PASS=`echo ${RESULT} | jq '.pass'`
[ ${PASS} != 'true' ] && exit

POST_URL="https://${PORTAL_HOST}/teams/${TEAM_NAME}.json"
POST_DATA=`echo ${RESULT} | jq --argjson obj '{".sv": "timestamp"}' '.timestamp += $obj'`
curl -X POST "${POST_URL}" --data "${POST_DATA}"