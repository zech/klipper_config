#!/bin/bash

### Path to your config folder you want to backup
config_folder=~/klipper_config

pull_config(){
  cd $config_folder
  git pull
}

pull_config
