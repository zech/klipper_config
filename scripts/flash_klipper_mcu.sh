#!/bin/bash
cd ~/klipper
make clean

echo "Updating Klipper repository"
git pull
echo

flash_octopus() {
  make clean KCONFIG_CONFIG=.config.octopus
  make menuconfig KCONFIG_CONFIG=.config.octopus
  make KCONFIG_CONFIG=.config.octopus
  read -p "BTT Octopus firmware built. Check for errors. Press [Enter] to continue. [CTRL+C] to abort."
  make flash KCONFIG_CONFIG=.config.octopus FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_stm32f446xx_22003500165053424E363620-if00
}

flash_rpi() {
  make clean KCONFIG_CONFIG=.config.rpi
  make menuconfig KCONFIG_CONFIG=.config.rpi
  make KCONFIG_CONFIG=.config.rpi
  read -p "Raspberry Pi firmware built. Check for errors. Press [Enter] to continue. [CTRL+C] to abort."
  make flash KCONFIG_CONFIG=.config.rpi
}

flash_seeed() {
  make clean KCONFIG_CONFIG=.config.seeed
  make menuconfig KCONFIG_CONFIG=.config.seeed
  make KCONFIG_CONFIG=.config.seeed
  read -p "Raspberry Pico 2040 firmware built. Check for errors. Press [Enter] to continue. [CTRL+C] to abort."
  make flash KCONFIG_CONFIG=.config.seeed FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_rp2040_4150325537323119-if00
}

PS3="Select what you want to flash: "
select  mcu in "All but RP2040 (default)" "All" "BTT Octopus" "Raspberry Pi" "Raspberry Pico 2040" "Quit"; do
  case $mcu in
    "Quit")
      exit
      ;;
    "BTT Octopus")
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_octopus
      sudo service klipper start
      ;;

    "Raspberry Pi")
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_rpi
      sudo service klipper start
      ;;

    "Raspberry Pico 2040")
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_seeed
      sudo service klipper start
      ;;

    "All")
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_octopus
      flash_rpi
      flash_seeed
      sudo service klipper start
      ;;

    "All but RP2040 (default)")
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_octopus
      flash_rpi
      sudo service klipper start
      ;;

    *)
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_octopus
      flash_rpi
      sudo service klipper start
      ;;
  esac
done


cd -
