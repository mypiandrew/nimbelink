#!/bin/bash
#
# NIMBELINK AUTO FIRMWARE SWITCH BASED ON SIM
#
# This enables or disables the modems GPS receiver and NMEA feed
#
# SEE AT COMMANDS for more information
#

if   [[ "$1" == "on"   ]] ; then
        GPSACTION=1
elif [[ "$1" == "off"  ]]; then
        GPSACTION=0
elif [[ "$1" == "feedon"  ]]; then
        GPSACTION=2		
elif [[ "$1" == "feedoff"  ]]; then
        GPSACTION=3		
elif [[ "$1" == "oneshot" ]] ; then
        GPSACTION=4
else
    echo
    echo " NimbeLink Telit GPS Configuration"
    echo " *****************************************"
    echo
    echo " $0 [on|off|oneshot]"
    echo
    echo " on      = Enable GPS receiver"
    echo " off     = Disable GPS receiver "
	echo " feedon  = Enable NMEA feed on /dev/modemGPS"
	echo " feedoff = disable GPS NMEA feed on /dev/modemGPS"
    echo " oneshot =  print a single GPS NMEA reading"
    echo
    exit
fi




chat -Vs TIMEOUT 2 ECHO OFF "" "ATZ" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log

#################### MODEM VENDOR CHECK

chat -Vs TIMEOUT 2 ECHO OFF "" "ATI4" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
REGEX_NIMBELINK='.*LE910C1-NF*'

RESPONSE=$(</tmp/log)

if [[ $RESPONSE =~ $REGEX_NIMBELINK ]] ; then
    MODEM=4   # QUECTEL
else

    echo "Not a NimbeLink LE910C1-NF Modem"
    exit
fi

#################### CONFIGURE

case $GPSACTION in

    0) # OFF
		chat -Vs TIMEOUT 1 "" 'AT$GPSP=0' "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log		
		sleep 1 
		chat -Vs TIMEOUT 1 "" "AT#GPIO=5,0,1,0" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log		
		if [[ "$2" != "-q" ]]; then
			echo "GPS Receiver Now OFF"
		fi
	;;
    1) # ON
		chat -Vs TIMEOUT 1 "" "AT#GPIO=5,1,1,0" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
		sleep 1 
		chat -Vs TIMEOUT 1 "" 'AT$GPSP=1' "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log		
		if [[ "$2" != "-q" ]]; then
			echo "GPS Receiver Now ON"
		fi		
	;;
    2) # FEED ON
		chat -Vs TIMEOUT 1 "" 'AT$GPSNMUN=2,0,0,0,1,1,0' "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
		if [[ "$2" != "-q" ]]; then
			echo "GPS Feed on /dev/modemGPS Now ON"
		fi	   
	;;
    3) # FEED OFF
		chat -Vs TIMEOUT 1 "" 'AT$GPSNMUN=0' "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
		if [[ "$2" != "-q" ]]; then
			echo "GPS Feed on /dev/modemGPS Now OFF"
		fi	   
	;;
    4) # ONE-SHOT READING
	# AT$GPSACP
	# $GPSACP: 144253.000,5143.5329N,00212.1938W,0.8,39.5,3,159.6,0.0,0.0,210622,08,02
	# OK
	echo "oneshot"
		chat -Vs TIMEOUT 1 "" 'AT$GPSACP' "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
		REGEX='(\$GPSACP: (.+),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(.*),(..))'
		RESPONSE=$(</tmp/log)
		if [[ $RESPONSE =~ $REGEX ]]
		then
			NMEA="${BASH_REMATCH[1]}"
			TIME="${BASH_REMATCH[2]}"
			LAT="${BASH_REMATCH[3]}"
			LONG="${BASH_REMATCH[4]}"
			DATE="${BASH_REMATCH[11]}"
			NUMSATS="${BASH_REMATCH[12]}"
		
			if [[ "$2" == "-q" ]]; then
				echo "NMEA=\"${NMEA}\""
				echo "DATE=\"${DATE}\""
				echo "TIME=\"${TIME}\""
				echo "LAT=\"${LAT}\""
				echo "LONG=\"${LONG}\""
				echo "NUMSATS=\"${NUMSATS}\""
				
			else
				echo "${NMEA}"				
			fi
		fi
	;;
	*) # DEFAULT
		if [[ "$2" != "-q" ]]; then
			echo "Unknown Option Selected"
		fi	   
	;;
esac	



