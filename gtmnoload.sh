#!/bin/bash

## Copyright ©UDPTeam
## Script to keep-alive your DNSTT server domain record query from target resolver/local dns server
## Run this script excluded to your VPN tunnel (split vpn tunneling mode)
## run command: ./globe-civ3.sh l

## Your DNSTT Nameserver & your Domain `A` Record
NS='sdns.myudp.elcavlaw.com'
A='myudp.elcavlaw.com'
NS1='sdns.myudph.elcavlaw.com'
A1='myudph.elcavlaw.com'
NS2='sdns.myudp1.elcavlaw.com'
A2='myudp1.elcavlaw.com'
NS3='ns-sgfree.elcavlaw.com'
A3='sgfree.elcavlaw.com'
## Repeat dig cmd loop time (seconds) (positive integer only)
LOOP_DELAY=5

## Add your DNS here
declare -a HOSTS=('112.198.115.44' '112.198.115.36' '124.6.181.20' '124.6.181.12' '124.6.181.36' '112.198.126.124' '112.198.126.116' '112.198.126.44')

## Linux' dig command executable filepath
## Select value: "CUSTOM|C" or "DEFAULT|D"
DIG_EXEC="DEFAULT"
## if set to CUSTOM, enter your custom dig executable path here
CUSTOM_DIG=/data/data/com.termux/files/home/go/bin/fastdig

######################################
######################################
######################################
######################################
######################################
VER=0.2
MAX_RETRIES=3

case "${DIG_EXEC}" in
 DEFAULT|D)
 _DIG="$(command -v dig)"
 ;;
 CUSTOM|C)
 _DIG="${CUSTOM_DIG}"
 ;;
esac

if [ ! $(command -v ${_DIG}) ]; then
 printf "%b" "Dig command failed to run, " \
 "please install dig(dnsutils) or check " \
 "\$DIG_EXEC & \$CUSTOM_DIG variable inside $( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/$(basename "$0") file.\n" && exit 1
fi

endscript() {
 unset NS A NS1 A1 NS2 A2 NS3 A3 LOOP_DELAY HOSTS _DIG DIG_EXEC CUSTOM_DIG T R M
 exit 1
}

trap endscript 2 15

check(){
 for ((i=0; i<"${#HOSTS[*]}"; i++)); do
  for R in "${A}" "${NS}" "${A1}" "${NS1}" "${A2}" "${NS2}" "${A3}" "${NS3}" ; do
   T="${HOSTS[$i]}"
   retry=0
   while [ "${retry}" -lt "${MAX_RETRIES}" ]; do
    IP=$(timeout -k 3 3 ${_DIG} @${T} ${R} | tail -n 1)
    if [ -n "${IP}" ]; then
     M=32
     break
    else
     M=31
     retry=$((retry + 1))
    fi
   done
   echo -e "\e[1;${M}m\$ R:${R} D:${T} IP:${IP}\e[0m"
   unset T R M
  done
 done
}

echo "DNSTT Keep-Alive script <Lantin Nohanih>"
echo -e "DNS List: [\e[1;34m${HOSTS[*]}\e[0m]"
echo "CTRL + C to close script"

[[ "${LOOP_DELAY}" -eq 1 ]] && let "LOOP_DELAY++";

case "${@}" in
 loop|l)
 echo "Script loop: ${LOOP_DELAY} seconds"
 while true; do
  check
  echo '.--. .-.. . .- ... .     .-- .- .. -'
  sleep ${LOOP_DELAY}
 done
 ;;
 *)
 check
 ;;
esac

exit 0
