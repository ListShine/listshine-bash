#!/usr/bin/env bash
set -ue
set -o pipefail

: ${LISTSHINE_HOST:="https://send.listshine.com/api/v1/"}

if [[ "x$LISTSHINE_API_KEY" = "x" ]]; then
    echo "You need to export LISTSHINE_API_KEY before using this script"
    exit 1
fi

CURL_COMMAND=/usr/bin/curl 
[[ ! -f $CURL_COMMAND ]] && { echo "no $CURL_COMMAND, exiting"  && exit 1; }

JQ_COMMAND=/usr/bin/jq 
[[ ! -f $JQ_COMMAND ]] && { echo "no $JQ_COMMAND, exiting"  && exit 1; }

# retrieve email from contactlist
retrieve() {
    local contactlist_uuid=$1
    local email=$2
    local url=$LISTSHINE_HOST/escontact/contactlist/$contactlist_uuid/
    local json=$(cat <<EOF
{"filters":[{"filter_type":"equal","filter_field":"contactlist_uuid","filter_value":"$contactlist_uuid"},{"filter_type":"equal","filter_field":"email","filter_value":"$email"}]}
EOF
    )
    $CURL_COMMAND -s -G -H "Authorization: Token $LISTSHINE_API_KEY" \
			     --data-urlencode "jsonfilter=$json" $url
}
# subscribe email to contactlist
subscribe() {
    local contactlist_uuid=$1
    local json=$2
    local url=$LISTSHINE_HOST/escontact/contactlist/subscribe/$contactlist_uuid/
    response=$($CURL_COMMAND -s -H "Authorization: Token $LISTSHINE_API_KEY" \
			     -H "Content-Type: application/json" \
			     -d "$json" \
			     --write-out %{http_code} --output /dev/null $url)
    [[ "$response"=="201" ]] 
}

# unsubscribe contact from contactlist 
unsubscribe() {
    local contactlist_uuid=$1
    local email=$2
    local esid=$(retrieve $contactlist_uuid $email | jq -r ".results[0].id") # get first id from result
    if [[ $esid != "null" ]]; then

	local url=$LISTSHINE_HOST/escontact/contactlist/$contactlist_uuid/contact/$esid/unsubscribe/
	response=$($CURL_COMMAND -s -X POST -H "Authorization: Token $LISTSHINE_API_KEY" \
				-H "Content-Type: application/json" \
				--write-out %{http_code} --output /dev/null $url)
	echo $response
    fi
    [[ "$response"=="201" ]] 
}
