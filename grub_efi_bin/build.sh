#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# shellcheck disable=SC2034
FGGRN="\033[32m"; FGRED="\033[31m"; FGWHT="\033[97m"; INV="\033[7m";
BGGRN="\033[42m"; BGRED="\033[41m"; BGWHT="\033[107m"; NC="\033[0m";

# These seemed to work fine.
GRUB_MODULES="part_gpt part_msdos png"
# An idea I had to include all modules. Not necessary and breaks basic
# functionality in some parts.
#GRUB_MODULES="$(
#  find /usr/lib/grub/${grub_arch}/ -name "*.mod" \
#  | xargs basename -s ".mod"
#)"
# FRom my old AskUbuntu answer.
#GRUB_MODULES="
#  fat iso9660 part_gpt part_msdos
#  normal boot linux configfile loopback chain
#  efifwsetup efi_gop efi_uga
#  ls search search_label search_fs_uuid search_fs_file
#  gfxterm gfxterm_background gfxterm_menu test all_video loadenv
#  exfat ext2 ntfs btrfs hfsplus udf
#"


usage() {
  echo "Creates GRUB EFI images"
  echo ""
  echo "./build [ architecture ] \"[ modules ]\""
  echo ""
  echo "- architecture = optional = \`all\` or any of: arm, arm64, i386 x86_64"
  echo "- modules = optional = any that are included in GRUB"
  echo ""
  exit 1
}


err() {                                                                         
  echo >&2 -e "${BGRED}${FGWHT} ERR ${NC} $(date --rfc-3339=sec):\n $*"         
}                                                                               


get_packages() {

  GRUB_PKG_VER="$(
    curl -s "https://packages.ubuntu.com/${UBUNTU_CODENAME}/grub-efi-arm-bin" \
    | awk '/<h1>Package:/ {gsub(/\(|\)/,""); print $3}'
  )"

  for file in "grub-efi-arm-bin_${GRUB_PKG_VER}_armhf.deb" \
              "grub-efi-ia32-bin_${GRUB_PKG_VER}_amd64.deb" \
              "grub-efi-arm64-bin_${GRUB_PKG_VER}_arm64.deb"; do

    if [[ "${file}" == "grub-efi-arm64-bin_${GRUB_PKG_VER}_arm64.deb" ]]; then 
      wget "http://ports.ubuntu.com/pool/main/g/grub2-unsigned/${file}"
    elif [[ "${file}" == "grub-efi-ia32-bin_${GRUB_PKG_VER}_amd64.deb" ]]; then
      wget "http://archive.ubuntu.com/ubuntu/pool/main/g/grub2/${file}"
    else
      wget "http://ports.ubuntu.com/pool/main/g/grub2/${file}"
    fi

    sudo dpkg -i --force-architecture "${file}"

    rm "${file}"
  done
}

 
install_packges() {
  # For the moment we only attempt to install packages here, we will not uninstall them.
  case "${ID}" in
    "ubuntu")
      [[ "$(uname -m)" == "x86_64" ]] && get_packages
      #sudo apt-get --no-install-recommends install \
      #  grub-efi-amd64-bin \
      #  grub-efi-ia32-bin
      #sudo apt-get install \
      #  grub-efi-amd64-bin \
      #  grub-efi-arm-bin \
      #  grub-efi-arm64-bin \
      #  grub-efi-ia32-bin
      ;;
    "fedora")
      # Fedora has no arm modules? At least ARM64 packages seem to be available out of the box.
      sudo yum install \
        grub2-efi-aa64-modules \
        grub2-efi-ia32-modules \
        grub2-efi-x64-modules
      ;;
    *)
      err "Unsupported distribution"
      ;;
  esac
}


make_images() {
  if [[ "${GRUB_ARCH}" == "all" ]]; then
    case "${ID}" in
      "fedora")
        make_grub_image "result_${ID}_${GRUB_VER}/bootaa64.efi" "arm64-efi"
        make_grub_image "result_${ID}_${GRUB_VER}/bootia32.efi" "i386-efi"
        make_grub_image "result_${ID}_${GRUB_VER}/bootx64.efi" "x86_64-efi"
        ;;
      "ubuntu")
        make_grub_image "result_${ID}_${GRUB_VER}/bootaa64.efi" "arm64-efi"
        make_grub_image "result_${ID}_${GRUB_VER}/bootarm.efi" "arm-efi"
        make_grub_image "result_${ID}_${GRUB_VER}/bootia32.efi" "i386-efi"
        make_grub_image "result_${ID}_${GRUB_VER}/bootx64.efi" "x86_64-efi"
        ;;
    esac
  else
    case "${GRUB_ARCH}" in
      "aa64"|"arm64")
        make_grub_image "result_${ID}_${GRUB_VER}/bootaa64.efi" "arm64-efi"
        ;;
      "arm")
        make_grub_image "result_${ID}_${GRUB_VER}/bootarm.efi" "arm-efi"
        ;;
      "ia32"|"i368"|"i686")
        make_grub_image "result_${ID}_${GRUB_VER}/bootia32.efi" "i386-efi"
        ;;
      "x64"|"x86_64")
        make_grub_image "result_${ID}_${GRUB_VER}/bootx64.efi" "x86_64-efi"
        ;;
    esac
  fi
}


make_grub_image() {
  # Create a temporary configuration. Source:
  # https://wiki.archlinux.org/index.php/GRUB/Tips_and_tricks#GRUB_standalone
  # shellcheck disable=SC2016
  echo 'configfile ${cmdpath}/grub.cfg' > "/tmp/grub.cfg"

  #grub-mkstandalone -v \
  grub-mkstandalone \
    --output="${1}" \
    --format="${2}" \
    --locales="en@quot" \
    --themes="" \
    --modules="${GRUB_MODULES}" \
    "boot/grub/grub.cfg=/tmp/grub.cfg"
}


main() {

  # Simplistic argparse.
  case $# in
    0)
      GRUB_ARCH="$(uname -m)"
      ;;
    1)
      GRUB_ARCH="${1}"
      ;;
    2)
      GRUB_ARCH="${1}"
      GRUB_MODULES="${2}"
      ;;
    *)
      usage
      ;;
  esac

  readonly GRUB_ARCH GRUB_MODULES

  if [[ -d "result" ]]; then
    err "Cannot create symlink 'result' because a folder of the same name already exists!"
    exit 1
  fi

  if [[ -r "/etc/os-release" ]]; then
    # shellcheck disable=SC1091
    source "/etc/os-release"
  else
    err "Unsupported Linux distribution found!"
    exit 1
  fi

  GRUB_VER="$(grub-mkstandalone -V | awk '/^grub-mkstandalone/ {print $3}')"

  # Install distribution packages if we need to create any other architecture
  # than the host architecture.
  [[ "$(uname -m)" != "${GRUB_ARCH}" ]] && install_packges

  if [[ -d "result_${ID}_${GRUB_VER}" ]]; then
    err "Directory 'result_${ID}_${GRUB_VER}' already exists!"
  fi

  mkdir "result_${ID}_${GRUB_VER}"

  make_images

  # Update link so that other scripts will find the new images.
  ln -svf "result_${ID}_${GRUB_VER}" "result"
}

main "$@"

