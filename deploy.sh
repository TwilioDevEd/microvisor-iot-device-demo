#!/usr/bin/env bash

show_help() {
    echo -e "Usage:\n"
    echo -e "  deploy [-l] [-h]\n"
    echo -e "Options:\n"
    echo "  -l / --log      After deployment, start log streaming"
    echo "  -h / --help     Show this help screen"
    echo
}

do_log=0

for arg in "$@"; do
    check_arg=${arg,,}
    if [[ "$check_arg" = "--log" || "$check_arg" = "-l" ]]; then
        do_log=1
    elif [[ "$check_arg" = "--help" || "$check_arg" = "-h" ]]; then
        show_help
        exit 0
    fi
done

upload_action=$(curl -X POST https://microvisor-upload.twilio.com/v1/Apps -H "Content-Type: multipart/form-data" -u ${TWILIO_API_KEY}:${TWILIO_API_SECRET} -s -F File=@./build/App_Code/mv-iot-device.zip)

app_sid=$(echo "${upload_action}" | jq -r '.sid')

if [[ -z "${app_sid}" ]]; then
    echo "ERROR -- Could not upload app"
    exit 1
else
    echo "Assigning app ${app_sid} to device ${MV_DEVICE_SID}"
    update_action=$(curl -X POST https://microvisor.twilio.com/v1/Devices/${MV_DEVICE_SID} -u ${TWILIO_API_KEY}:${TWILIO_API_SECRET} -s -d AppSid=${app_sid})
    up_date=$(echo "${update_action}" | jq -r '.date_updated')

    if [[ "${up_date}" != "null" ]]; then
        echo "Updated device ${MV_DEVICE_SID} @ ${up_date}"

        if [[ $do_log -eq 1 ]]; then
            echo "Logging from ${MV_DEVICE_SID}..."
            twilio microvisor:logs:stream ${MV_DEVICE_SID}
        fi
    else
        echo "ERROR -- Could not assign app ${app_sid} to device ${MV_DEVICE_SID}"
        echo "Response from server:"
        echo "$update_action"
        exit 1
    fi
fi

exit 0