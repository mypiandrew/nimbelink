#!/bin/bash
#
# NIMBELINK AT&T/VERIZON/T-MOBILE FIRMWARE SWITCH 
#
# This allows the user to switch the modems firmware between
# Verizon/AT&T/TMOBILE Firmware 
#
# SEE AT COMMANDS PDF 
#

FWSWITCHMODE=0

if   [[ "$1" == "verizon"   ]] ; then
    FWSWITCHMODE=1
elif [[ "$1" == "att"  ]]; then
    FWSWITCHMODE=0
elif [[ "$1" == "tmobile"  ]]; then
    FWSWITCHMODE=2
elif [[ "$1" == "read" ]] ; then
    FWSWITCHMODE=3
else
    echo
    echo " NimbeLink Telit Auto Firmware Mode Switch"
    echo " *****************************************"
    echo
    echo " $0 [att|verizon|tmobile]"
    echo
    echo " att     = Switch to ATT firmware,equivelent to AT#FWSWITCH=0,1"
    echo " verizon = Switch to ATT firmware,equivelent to AT#FWSWITCH=1,1"
    echo " tmobile = Disable auto firmware switch,equivelent to AT#FWSWITCH=2,1"	
    echo " read    = show current state"
    echo
    exit
fi


chat -Vs TIMEOUT 2 ECHO OFF "" "ATZ" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log


chat -Vs TIMEOUT 2 ECHO OFF "" "ATI4" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
REGEX_NIMBELINK='.*LE910C1-NF*'

RESPONSE=$(</tmp/log)

if [[ $RESPONSE =~ $REGEX_NIMBELINK ]] ; then
    MODEM=4   # QUECTEL
else

    echo "Not a NimbeLink LE910C1-NF Modem"
    exit
fi


chat -Vs TIMEOUT 1 "" "AT#FWSWITCH?" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
REGEX='.FWSWITCH:.([0-9]),[0-9],[0-9]'
RESPONSE=$(</tmp/log)
MODE=""
if [[ $RESPONSE =~ $REGEX ]]
then
    MODE="${BASH_REMATCH[1]}"
fi

if [[ "$2" == "-q" ]]; then
    echo "OLDMODE=$MODE"
else
    if [[ "$MODE" -eq 0 ]] ; then
        echo "Current Setting : Firmware = AT&T"
    elif [[ "$MODE" -eq 1 ]] ; then
        echo "Current Setting : Firmware = VERIZON"
	elif [[ "$MODE" -eq 2 ]] ; then
        echo "Current Setting : Firmware = TMOBILE"	
    else
        echo "   ** UNKNOWN ** "
    fi
fi

if [[ "${FWSWITCHMODE}" -eq 3 ]]; then
    exit
fi

if [[ "$2" != "-q" ]]; then
    echo "Changing Setting..."
fi


chat -Vs TIMEOUT 1 "" "AT#FWSWITCH=${FWSWITCHMODE},1" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log

if [[ "$2" != "-q" ]]; then
    echo -en "Waiting for modem to reset"
fi

# wait for modem to reset
while [ -L /dev/modemAT ]
do
	if [[ "$2" != "-q" ]]; then
		echo -en "."
	fi    
    sleep 1
done

if [[ "$2" != "-q" ]]; then
	echo
	echo -en "Waiting for modem to reappear"
fi
    

while [ ! -L /dev/modemAT ]
do
	if [[ "$2" != "-q" ]]; then
		echo -en "."
	fi    
    sleep 1
done
sleep 2

if [[ "$2" != "-q" ]]; then
	echo
	echo "Modem Back"
fi


# Run ATZ (terminal reset) untill we get an OK response 
chat -Vs TIMEOUT 2 ECHO OFF "" "ATZ" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
chat -Vs TIMEOUT 2 ECHO OFF "" "ATZ" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
chat -Vs TIMEOUT 2 ECHO OFF "" "ATZ" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log


chat -Vs TIMEOUT 2 ECHO OFF "" "ATI4" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
REGEX_NIMBELINK='.*LE910C1-NF*'

RESPONSE=$(</tmp/log)

if [[ $RESPONSE =~ $REGEX_NIMBELINK ]] ; then
    MODEM=4   # QUECTEL
else

    echo "Can't detect modem after reset"
    exit
fi

chat -Vs TIMEOUT 1 "" "AT#FWSWITCH?" "OK" >/dev/modemAT </dev/modemAT 2>/tmp/log
REGEX='.FWSWITCH:.([0-9]),[0-9],[0-9]'
RESPONSE=$(</tmp/log)
MODE=""
if [[ $RESPONSE =~ $REGEX ]]
then
    MODE="${BASH_REMATCH[1]}"
fi

if [[ "$2" == "-q" ]]; then
    echo "NEWMODE=$MODE"
else
    if [[ "$MODE" -eq 0 ]] ; then
        echo "New Setting : Firmware = AT&T"
    elif [[ "$MODE" -eq 1 ]] ; then
        echo "New Setting : Firmware = VERIZON"
	elif [[ "$MODE" -eq 3 ]] ; then
        echo "New Setting : Firmware = TMOBILE"	
    else
        echo "   ** UNKNOWN ** "
    fi
fi

