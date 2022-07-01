# NimbeLink scripts to interact with Skywire Modems

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

The modem Modem Fiirmware Switch utility allows the user to ad-hoc switch the modem between AT&T/Verizon or T-MOBILE modes, to suit the installed SIM type.
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




