#!/usr/bin/env sh
currentwifi=$(networksetup -getairportnetwork en0 | awk '{ print $4 }');
if  [[ ${currentwifi} = 'WIFIonICE' ]];
then
  speed=$(curl -s 'https://iceportal.de/api1/rs/status' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/json' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://iceportal.de/' -H 'Cookie: dbsession=a0358574.5a8968f3efeb9; s_fid=3F4B32920E970B31-135178D603FF7A9C; gpv_pn=startseite; gvo_v25=Direct; s_cc=true; gpv_ln=0%25' | jq -r '.speed')

  echo ${speed}" km/h"
else
  echo ""
fi
