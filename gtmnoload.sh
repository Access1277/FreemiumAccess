#!/bin/bash

# Improved DNSTT Keep-Alive Script
# Copyright © ELCAVLAW
# Recoded by: LANTIN

# Your DNSTT Nameservers
NAMESERVERS=('sdns.myudp.elcavlaw.com' 'team-mamawers.elcavlaw.com')
# Your Domain `A` Record
A_RECORD='myudp.elcavlaw.com'
A_RECORD='mamawers.elcavlaw.com'

# Add your DNS here
HOSTS=('124.6.181.12' '112.198.115.44' '112.198.115.36')

# Loop delay in seconds (positive integer only)
LOOP_DELAY=5
if ! [[ "$LOOP_DELAY" =~ ^[1-9][0-9]*$ ]]; then
    echo "Invalid LOOP_DELAY. Must be a positive integer."
    exit 1
fi

# Check and set the dig command
DIG_EXEC=${DIG_EXEC:-"DEFAULT"} # Use DEFAULT if not set
CUSTOM_DIG='/data/data/com.termux/files/home/go/bin/fastdig'
DIG_CMD=""

# Determine the dig command based on user choice
case "${DIG_EXEC}" in
    DEFAULT|D) DIG_CMD="$(command -v dig)" ;;
    CUSTOM|C) DIG_CMD="${CUSTOM_DIG}" ;;
    *) echo "Invalid DIG_EXEC value. Please choose DEFAULT or CUSTOM."; exit 1 ;;
esac

# Verify that the dig command is available
[ -z "${DIG_CMD}" ] && { echo "Dig command not found. Please install dnsutils or set the correct path in CUSTOM_DIG."; exit 1; }

# Function to check the DNS
check_dns() {
    for host in "${HOSTS[@]}"; do
        for ns in "${NAMESERVERS[@]}" "${A_RECORD}"; do
            if ! timeout -k 3 3 "${DIG_CMD}" "@${host}" "${ns}" &> /dev/null; then
                echo "R:${ns} D:${host} - failure"
            else
                echo "R:${ns} D:${host} - success"
            fi
        done
    done
}

# Main execution
echo "DNSTT Keep-Alive script Modified by: LANTIN"
echo "DNS List: ${HOSTS[*]}"
echo "CTRL + C to close the script"

# Loop or single check based on argument
if [ "${1,,}" == "loop" ] || [ "${1,,}" == "l" ]; then
    echo "Script loop: ${LOOP_DELAY} seconds"
    while true; do
        check_dns
        echo 'LANTIN NOHANIH'
        sleep "${LOOP_DELAY}"
    done
else
    check_dns
fi

exit 0
