#!/bin/bash

# shellcheck disable=SC2034
FGGRN="\033[32m"; FGRED="\033[31m"; FGWHT="\033[97m"; INV="\033[7m";
BGGRN="\033[42m"; BGRED="\033[41m"; BGWHT="\033[107m"; NC="\033[0m";

default_size="4094"

create_image() {

  dd if=/dev/zero of="$1" bs=1M count="$2"

  # Create a filestem on the image with no reserved blocks.
  mkfs.ext4 -m 0 "$1"
}


ask_casper() {

  echo -en "\n${INV}> Size of casper-rw image? (default: ${default_size}) ${NC} "
  read -r casper_size
  
  case "${casper_size}" in
    "")
      create_image "result/casper-rw" "${default_size}";;
    100-99999)
      create_image "result/casper-rw" "${casper_size}";;
    *)
      echo "Selected size is out of range (100-99999)."
      exit 1;;
  esac
}


ask_home() {

  echo -en "\n${INV}> Size of home-rw image? (default: ${default_size}) ${NC} "
  read -r home_size
  
  case "${home_size}" in
    "")
      create_image "result/home-rw" "${default_size}";;
    100-99999)
      create_image "result/home-rw" "${home_size}";;
    *)
      echo "Selected size is out of range (100-99999)."
      exit 1;;
  esac
}


main() {

  mkdir -pv "result"

  echo -en "\n${INV}> Create casper-rw image? (Y/n) ${NC} "
  read -r tmp_casper
  
  case "${tmp_casper}" in
    n|no|N|NO)
      pass;;
    *)
      ask_casper;;
  esac

  echo -en "\n${INV}> Create home-rw image? (Y/n) ${NC} "
  read -r tmp_home
  
  case "${tmp_home}" in
    n|no|N|NO)
      pass;;
    *)
      ask_home;;
  esac
}

main "$@"

