# NimbeLink scripts to interact with Skywire Modems

##UDEV Rules

The udev rules file should be installed in /etc/udev/rules.d to allow easy access to the shortcuts below 
```
root@raspberrypi:~# ls /dev/modem* -l
lrwxrwxrwx 1 root root 7 Jul  1 11:12 /dev/modemAT -> ttyUSB4
lrwxrwxrwx 1 root root 7 Jul  1 11:12 /dev/modemGPS -> ttyUSB2
lrwxrwxrwx 1 root root 7 Jul  1 11:12 /dev/modemPPP -> ttyUSB3
lrwxrwxrwx 1 root root 7 Jul  1 11:12 /dev/modemS0 -> ttyUSB1
lrwxrwxrwx 1 root root 7 Jul  1 11:12 /dev/modemS1 -> ttyUSB2
lrwxrwxrwx 1 root root 7 Jul  1 11:12 /dev/modemS2 -> ttyUSB3
lrwxrwxrwx 1 root root 7 Jul  1 11:12 /dev/modemS3 -> ttyUSB4
lrwxrwxrwx 1 root root 7 Jul  1 11:12 /dev/modemS4 -> ttyUSB5
```

##Carrier Firmware Switching

The Modem Fiirmware Switch utility allows the user to ad-hoc switch the modem between AT&T/Verizon or T-MOBILE modes, to suit the installed SIM type.
This can also be run in silent mode with bash variable outputs for use with other scripts by adding the additonal -q option flag.
See below example

```
root@raspberrypi:~# ./nlfwswitch.sh

 NimbeLink Telit Auto Firmware Mode Switch
 *****************************************

 ./nlfwswitch.sh [att|verizon|tmobile]

 att     = Switch to ATT firmware,equivelent to AT#FWSWITCH=0,1
 verizon = Switch to ATT firmware,equivelent to AT#FWSWITCH=1,1
 tmobile = Disable auto firmware switch,equivelent to AT#FWSWITCH=2,1
 read    = show current state

root@raspberrypi:~# ./nlfwswitch.sh read
Current Setting : Firmware = VERIZON

root@raspberrypi:~# ./nlfwswitch.sh att
Current Setting : Firmware = VERIZON
Changing Setting...
Waiting for modem to reset...
Waiting for modem to reappear.........
Modem Back
New Setting : Firmware = AT&T

root@raspberrypi:~# ./nlfwswitch.sh read
Current Setting : Firmware = AT&T

root@raspberrypi:~# ./nlfwswitch.sh verizon
Current Setting : Firmware = AT&T
Changing Setting...
Waiting for modem to reset...
Waiting for modem to reappear..........
Modem Back
New Setting : Firmware = VERIZON
```

##GPS Receiver Script

This script allows the user to start-up to modems GPS functionality, including starting the automated NMEA feed on /dev/modemGPS.
The GPS feed will take about 1-3mins to get a first fix and start reporting valid data.

Note you will need to attach an active GPS antenna to the GPS port on the SIM side of the modem module PCB

root@raspberrypi:~# ./nlgps.sh

```
 NimbeLink Telit GPS Configuration
 *****************************************

 ./nlgps.sh [on|off|oneshot]

 on      = Enable GPS receiver
 off     = Disable GPS receiver
 feedon  = Enable NMEA feed on /dev/modemGPS
 feedoff = disable GPS NMEA feed on /dev/modemGPS
 oneshot =  print a single GPS NMEA reading

root@raspberrypi:~# ./nlgps.sh on
GPS Receiver Now ON
root@raspberrypi:~# ./nlgps.sh oneshot
$GPSACP: 112100.000,5143.5040N,00212.1727W,1.5,-44.4,3,144.4,0.0,0.0,010722,05,02
root@raspberrypi:~# ./nlgps.sh feedon
GPS Feed on /dev/modemGPS Now ON
root@raspberrypi:~# minicom -D /dev/modemGPS -b 9600
Welcome to minicom 2.7.1

OPTIONS: I18n
Compiled on Aug 13 2017, 15:25:34.
Port /dev/modemGPS, 12:29:46

Press CTRL-A Z for help on special keys

$GPGSV,3,1,12,01,12,246,31,08,67,291,27,10,53,084,28,16,22,174,20,1*65
$GPGSV,3,2,12,21,45,251,44,23,31,050,31,27,65,116,30,30,10,305,38,1*6A
$GPGSV,3,3,12,32,03,120,18,07,09,277,,14,02,326,,15,03,019,,1*6C
$GPRMC,112949.00,A,5143.514912,N,00212.186019,W,0.0,205.6,010722,4.3,W,A,V*46
$GPGSV,3,1,12,01,12,246,31,08,67,291,23,10,53,084,23,16,22,174,20,1*6A
$GPGSV,3,2,12,21,45,251,44,23,31,050,29,27,65,116,28,30,10,305,38,1*6A
$GPGSV,3,3,12,32,03,120,18,07,09,277,,14,02,326,,15,03,019,,1*6C
$GPRMC,112950.00,A,5143.514908,N,00212.186019,W,0.0,205.6,010722,4.3,W,A,V*45

```

