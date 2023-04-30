#!/bin/bash
cd ~/klipper
make clean

echo "Updating Klipper repository"
git pull
echo

flash_octopus() {
  make clean KCONFIG_CONFIG=~/klipper_config/scripts/.config.octopus
  make menuconfig KCONFIG_CONFIG=~/klipper_config/scripts/.config.octopus
  make KCONFIG_CONFIG=~/klipper_config/scripts/.config.octopus
  read -p "BTT Octopus firmware built. Check for errors. Press [Enter] to continue. [CTRL+C] to abort."
  make flash KCONFIG_CONFIG=~/klipper_config/scripts/.config.octopus FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_stm32f446xx_22003500165053424E363620-if00
}

flash_rpi() {
  make clean KCONFIG_CONFIG=~/klipper_config/scripts/.config.rpi
  make menuconfig KCONFIG_CONFIG=~/klipper_config/scripts/.config.rpi
  make KCONFIG_CONFIG=~/klipper_config/scripts/.config.rpi
  read -p "Raspberry Pi firmware built. Check for errors. Press [Enter] to continue. [CTRL+C] to abort."
  make flash KCONFIG_CONFIG=~/klipper_config/scripts/.config.rpi
}

flash_adxl_rp2040() {
  make clean KCONFIG_CONFIG=~/klipper_config/scripts/.config.adxl
  make menuconfig KCONFIG_CONFIG=~/klipper_config/scripts/.config.adxl
  make KCONFIG_CONFIG=~/klipper_config/scripts/.config.adxl
  read -p "ADXL Seeed XIAO RP2040 firmware built. Check for errors. Press [Enter] to continue. [CTRL+C] to abort."
  make flash KCONFIG_CONFIG=~/klipper_config/scripts/.config.adxl FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_rp2040_4150325537323119-if00
}

flash_ercf_samd21() {
  make clean KCONFIG_CONFIG=~/klipper_config/scripts/.config.ercf
  make menuconfig KCONFIG_CONFIG=~/klipper_config/scripts/.config.ercf
  make KCONFIG_CONFIG=~/klipper_config/scripts/.config.ercf
  read -p "ERCF Seeed XIAO SAMD21 firmware built. Check for errors. Press [Enter] to continue. [CTRL+C] to abort."
  make flash KCONFIG_CONFIG=~/klipper_config/scripts/.config.ercf FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_samd21g18a_CB0137DD534D535020312E3025010BFF-if00
}

PS3="Select what you want to flash: "
select  mcu in "BTT Octopus" "Raspberry Pi" "ADXL Seeed XIAO RP2040" "ERCF Seeed XIAO SAMD21" "All but ADXL & ERCF (default)" "All but ADXL" "All" "Quit"; do
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

    "ADXL Seeed XIAO RP2040")
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_adxl_rp2040
      sudo service klipper start
      ;;

    "ERCF Seeed XIAO SAMD21")
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_ercf_samd21
      sudo service klipper start
      ;;

    "All")
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_octopus
      flash_rpi
      flash_adxl_rp2040
      flash_ercf_samd21
      sudo service klipper start
      ;;

    "All but ADXL")
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_octopus
      flash_rpi
      flash_ercf_samd21
      sudo service klipper start
      ;;

    "All but ADXL & ERCF (default)")
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_octopus
      flash_rpi
      sudo service klipper start
      ;;

    *)
      read -p "Do you really want to build Klipper for BTT Octopus and Raspberry Pi?. Press [Enter] to continue. [CTRL+C] to abort."
      echo "Stopping Klipper"
      sudo service klipper stop
      flash_octopus
      flash_rpi
      sudo service klipper start
      ;;
  esac
done

cd -
