TEAM_ID=LPEDTJU8WA
TOKEN_KEY_FILE_NAME=/Users/olia/code/PushesTutorialApp/AuthKey_82G3F36P69.p8
AUTH_KEY_ID=82G3F36P69
TOPIC=test.PushesTutorialApp

DEVICE_TOKEN=$1

APNS_HOST_NAME=api.sandbox.push.apple.com

# Test that you can connect to APNs using this command:
# openssl s_client -connect "${APNS_HOST_NAME}":443

# Set these additional shell variables just before sending a push notification:
JWT_ISSUE_TIME=$(date +%s)
JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"
JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

PAYLOAD='{
  "aps": {
    "alert": {
      "title": "Lbhe Gnetrg",
      "body": "Guvf vf lbhe arkg nffvtazrag."
    },
    "sound": "default",
    "badge": 1,
    "mutable-content": 1,
    "interruption-level": "time-sensitive"
  },
  "media-url":
          "uggcf://jbyirevar.enljraqreyvpu.pbz/obbxf/abg/ohaal.zc4"
}'

# Send the push notification using this command:
curl -v --header "apns-topic: $TOPIC" --header "apns-push-type: alert" --header "authorization: bearer $AUTHENTICATION_TOKEN" --data "${PAYLOAD}" --http2 https://${APNS_HOST_NAME}/3/device/${DEVICE_TOKEN}
