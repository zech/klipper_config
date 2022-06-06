#!/bin/bash

case $1 in
  start)
  systemctl list-jobs | egrep -q 'reboot.target.*start' && echo "starting reboot" >> /tmp/file
  systemctl list-jobs | egrep -q 'shutdown.target.*start' && echo "starting shutdown" >> /tmp/file
  ;;

  stop)
  systemctl list-jobs | egrep -q 'reboot.target.*start' || echo "stopping"  >> /tmp/file
  ;;
esac