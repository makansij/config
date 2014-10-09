#!/bin/bash
## WLAN Verbindungsskript
## elektronenblitz63 ubuntuusers.de 2012
## published under GPL v3
##
## Version 1.0.2.2 vom 26.Februar 2012
## Debug-Modus verbessert. Kleinere Fehler beseitigt.
##
## Skript
##
## freie Variablen
##

## Ethernet-Schnittstelle (LAN-Interface)
laniface="eth0"

## Schnittsetllenkonfiguration WLAN-Interface
wlaniface="wlan0"

## Konfiguration der Accesspoints
#
## Accesspoint Konfiguration
# SSID (Name) des WLAN Accesspoints eintragen
ssid="EasyBox-5B9636"

# MAC-Adresse des WLAN Accesspoints eintragen
mac="00:26:4d:5b:96:ba"

# Einstellungen zur Verschlüsselung (WPA1 und/oder WPA2)
# die Vorgabe deckt im Normalfall alle Konfigurationsmöglichkeiten ab
# Konfiguration wpa-supplicant
proto="WPA RSN"
key_mgmt="WPA-PSK"
pairwise="TKIP CCMP"
group="TKIP CCMP"

# WEP-Verschlüsselung
# Einstellungen zur Verschlüsselung (WEP-Zugangsschlüssel)
wkey="12345678901234567890abcdef"

# WPA1 - WPA2 - WPA1/2 Verschlüsselung
# Zugangskennwort in Klartext (WPA1/2-Zugangsschlüssel / PSK)
psk="4BDA6277F"

# Treiber für wpa_supplicant
wpadriver="wext"

## DHCP-Client
dhcpclient="dhclient"

## manuelle DNS (drei DNS Einträge, 1xDomain und 1xSearch sind möglich) - Startoption -D
# Beispiel:
# dns="nameserver 192.168.178.1 nameserver 192.168.178.1 nameserver 192.168.178.1 domain fritz.box search fritz.box"
dns="nameserver 8.8.4.4 nameserver 8.8.8.8 nameserver 213.73.91.35" 

## Pause bevor eine IP-Adresse angefordert wird
## diese Zeit in Sek. bleibt wpa_supplicant für den Verbindungsaufbau
connectsleep=15

## Pause in Sekunden für Konfigurationsparameter
## Vorgabewert 2
configdelay=2

## verwendetes Terminalprogramm
# kde > konsole oder xterm
# xfce > mousepad oder xterm
# gnome > gnome-terminal oder xterm
term=gnome-terminal

## Konfiguration Debug-Modus
# Dauer des Verbindungsversuchs in Sekunden
debugtime=45

# Protokolldatei
debugfile="WLAN_con_debug.txt"

## Ende freie Variablen

## Optionen
D=0
H=0
d=0
w=0
f=0

while getopts ":hDdwf" OPTION ; do
  case $OPTION in
    D) echo "manueller DNS"; D=1;;
    d) echo "WPA-Supplicant im Debug-Modus"; d=1;;
    f) echo "WPA-Supplicant im Debug-Modus, Protokolldatei wird angelegt"; f=1;;
    w) echo "WEP-Verschlüsselung aktiviert"; w=1;;
    h) echo "Hilfe angefordert"; H=1;;
  esac
done

if [ "$H" = "1" ]; then
  echo Verwendung: WLAN_con.sh [-start] [-restart] [-stop] [-h] [-D] [-d] [-f] [-w]
  echo Syntax:
  echo "sudo ./WLAN_con.sh startet mit Standardparametern, wie [-start]"
  echo "sudo ./WLAN_con.sh -start -w startet mit Standardparametern und verwendet WEP-Verschlüsselung"
  echo "sudo ./WLAN_con.sh -restart erneuert die Verbindung über DHCP"
  echo "sudo ./WLAN_con.sh -d startet im Debug-Modus. Informationen zum Verbindungsaufbau werden in einem Terminalfenster angezeigt."
  echo "sudo ./WLAN_con.sh -f startet im Debug-Modus. Informationen zum Verbindungsaufbau werden in einer Datei gespeichert."
  echo "sudo ./WLAN_con.sh -restart -D erneuert die Verbindung über DHCP, verwendet manuelle DNS"
  echo "sudo ./WLAN_con.sh -stop beendet die WLAN-Verbindung"
  echo "Ende"
  exit
fi

echo starte Konfiguration ...
echo

## Plausibilitätsprüfung WEP-Schlüssel
keycheck="`echo $wkey | egrep -o [A-Fa-f0-9]`"
keycheck="`echo $keycheck | tr -d " "`"
keylenght="`expr length $keycheck | egrep -wo '10|26'`"
keylenght=$[keylenght +1]

if [ $keycheck != $wkey ]; then
  echo "Unzulässige Zeichen im WEP-Schlüssel. [a-f] [A-F] [0-9] (hex-Code) sind erlaubt"
  exit
elif [ $keylenght = 1 ]; then
  echo "Länge des gewählten WEP-Schlüssels fehlerhaft, 10 Zeichen (64bit) oder 26 Zeichen (128bit) sind erlaubt"
  exit
fi

## be root if not
test `id -u` -eq 0 || exec sudo "$0" "$@"

if [ "$1" != "-start" ]; then
  echo stoppe alle Dienste, und Verbindungen ...

  defgw="`route -n | grep UG | awk {'print $2'}`"
  /sbin/route del default gw $defgw $wlaniface
  echo '' | tee /etc/resolv.conf
  killall wpa_supplicant
  sleep $configdelay
  /sbin/ifconfig $wlaniface down

  ## Restart Network-Manager - beende WLAN-Verbindung
  if [ "$1" = "-stop" ]; then
    echo
    echo "reaktiviere Network-Manager."
    sleep $configdelay
    service network-manager start
    echo "WLAN Konfiguration beendet."
    exit
  fi
fi

# Konfiguration wpa_supplicant
configfile=$home/wpa_supplicant.tmp
ctrliface="ctrl_interface=/var/run/wpa_supplicant"
eapolv="eapol_version=1"
apscan="ap_scan=1"
wpadriver=wext
success=0

# Konfiguration
ip link set $laniface down
 ip route del

 service network-manager stop
 sleep 1
 killall wpa_supplicant
 killall $dhcpclient
 sleep $configdelay
 /sbin/ifconfig $wlaniface down
 sleep $configdelay
 /sbin/ifconfig $wlaniface up
 sleep $configdelay

## WLAN-Verbindung vorbereiten
if [ "$w" = "0" ]; then
  echo $ctrliface | tee $configfile
  echo $eapolv | tee -a $configfile
  echo $apscan | tee -a $configfile
  echo 'network={' | tee -a $configfile
  echo ssid='"'$ssid'"' | tee -a $configfile
  echo bssid=$mac | tee -a $configfile
  echo proto=$proto | tee -a $configfile
  echo key_mgmt=$key_mgmt | tee -a $configfile
  echo pairwise=$pairwise | tee -a $configfile
  echo group=$group | tee -a $configfile
  echo psk='"'$psk'"' | tee -a $configfile
  echo '}' | tee -a $configfile
else
  echo $ctrliface | tee $configfile
  echo 'network={' | tee -a $configfile
  echo ssid='"'$ssid'"' | tee -a $configfile
  echo bssid=$mac | tee -a $configfile
  echo "key_mgmt=NONE" | tee -a $configfile
  echo wep_key0="$wkey" | tee -a $configfile
  echo wep_tx_keyidx=0 | tee -a $configfile
  echo '}' | tee -a $configfile
fi

echo "Starte WLAN-Verbindungsaufbau ..."
 echo

# Debug-Modus / Protokollierung
if [ "$f" = "1" ]; then
  echo "protokolliere Verbindungsvorgang für "$debugtime" Sekunden, bitte warten ..."
  echo
  /usr/bin/$term -e "/sbin/wpa_supplicant -i $wlaniface -D $wpadriver -c $configfile -d > $debugfile" &> /dev/null &
  sleep $debugtime
  killall wpa_supplicant
  echo "Protokollierung beendet. Informationen wurden in "`pwd`/$debugfile" abgelegt."
  exit
fi

# Debug-Modus / ohne Protokollierung
if [ "$d" = "1" ]; then
  /usr/bin/$term -e "/sbin/wpa_supplicant -i $wlaniface -D $wpadriver -c $configfile -d" &> /dev/null &
  echo "Pause, warte auf Verbindung ..."
  echo
  sleep $connectsleep
  echo "Fordere IP-Adresse an ..."
  /sbin/dhclient $wlaniface
else
  # Daemon-Modus
  /sbin/wpa_supplicant -i $wlaniface -D $wpadriver -c $configfile -B
  echo "Pause, warte auf Verbindung ..."
  echo
  sleep $connectsleep
  echo "Fordere IP-Adresse an ..."
  /sbin/dhclient $wlaniface
  sleep $configdelay
fi 

# manuelle DNS - Startoption -D
if [ "$D" = "1" ]; then
  echo "setze manuelle DNS"
  echo '# instant_ICS_WLAN_to_LAN.sh' | tee /etc/resolv.conf
  echo $dns | awk {'print $1,$2'} | tee -a /etc/resolv.conf
  echo $dns | awk {'print $3,$4'} | tee -a /etc/resolv.conf
  echo $dns | awk {'print $5,$6'} | tee -a /etc/resolv.conf 
  echo $dns | awk {'print $7,$8'} | tee -a /etc/resolv.conf
  echo $dns | awk {'print $9,$10'} | tee -a /etc/resolv.conf
  sleep $configdelay
fi

# Ausgabe der Konfiguration. Einstellungen der Schnittstellen,
# Routingtabelle und DNS prüfen

echo "prüfe Konfiguration ..."
echo
echo "Systemkonfiguration: /etc/resolv.conf"
/bin/cat /etc/resolv.conf
/sbin/route -n
echo
echo Konfiguration WLAN:
/sbin/ifconfig $wlaniface | egrep 'Link|inet Adresse'
echo
/sbin/iwconfig $wlaniface
echo
echo "Konfiguration beendet"

exit 0
