#!/bin/bash

poweroff() {
  echo "Signaling power off to smart switch..."
  /usr/bin/curl -fs -o /dev/null -v "http://voron2-power.webfinca.de/cm?cmnd=Backlog%20Delay%20600%3BPower1%20off"
}

/usr/bin/systemctl list-jobs | /usr/bin/egrep -q 'reboot.target.*start'
if [ $? -eq 0 ]; then
  echo "Rebooting... No poweroff."
  exit 0
fi

/usr/bin/systemctl list-jobs | /usr/bin/egrep -q 'halt.target.*start'
if [ $? -eq 0 ]; then
  poweroff
fi


/usr/bin/systemctl list-jobs | /usr/bin/egrep -q 'poweroff.target.*start'
if [ $? -eq 0 ]; then
  poweroff
fi
