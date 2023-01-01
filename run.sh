#!/bin/bash

# shellcheck disable=SC2034
FGGRN="\033[32m"; FGRED="\033[31m"; FGWHT="\033[97m"; INV="\033[7m"; 
BGGRN="\033[42m"; BGRED="\033[41m"; BGWHT="\033[107m"; NC="\033[0m";

# TODO: move to argparse, write usage, make global and readonly
INPUT_PATH="/media/bt/OEMDRV"
GLIUT_PATH="${INPUT_PATH}/efi/gli_ut"
EFI_FALLBACK="${INPUT_PATH}/efi/boot"
SELECTED_THEME="plain"


usage() {
  echo test
  exit 1
}


err() {
  echo >&2 -e "${BGRED}${FGWHT} ERR ${NC} $(date --rfc-3339=sec):\n $*"
}


get_fs_uuid() {

  local source_dev source_dev_uuid

  # The backslash disables alises, according to someone on StackOverflow.
  source_dev=$(\df --output=source "${1}" | tail -1)
  source_dev_uuid="$(
    find "/dev/disk/by-uuid" -lname "*/${source_dev##*/}" -printf %f
  )"

  echo "${source_dev_uuid}"
}


create_efi_fallback() {

  mkdir -pv "${EFI_FALLBACK}"

  rsync \
    --recursive \
    --perms \
    --times \
    "grub_efi_bin/result/" \
    "${EFI_FALLBACK}"

  sed -e "s/%%UUID%%/${FS_UUID}/g" \
    "templates/grub.cfg" \
  > "${EFI_FALLBACK}/grub.cfg"
}


update_grub_menu() {

  # Be a little forgving and create a backup for those tiny mishaps. Not meant
  # to be perfect!
  if [[ -e "${GLIUT_PATH}/grub_menu.cfg" ]]; then

    mv -vf "${GLIUT_PATH}/grub_menu.cfg" "${GLIUT_PATH}/grub_menu.bak"

  fi 

  # Ensure that UUIDs are up to date on the destination.
  for file in "grub.cfg" "grub_menu.cfg"; do

    sed -e "s/%%UUID%%/${FS_UUID}/g" \
      "templates/${file}" \
    > "${GLIUT_PATH}/${file}"

  done

  # Apply customization after header and before menu list.
  tmp_filename="templates-custom/${FS_UUID}_grub_menu_header.cfg"

  if [[ -e "${tmp_filename}" ]]; then

    cat "${tmp_filename}" >> "${GLIUT_PATH}/grub_menu.cfg"

  fi

  # Write the new GRUB menu list containing includes (source) from the library.
  cat "templates/grub_menu_list.cfg" >> "${GLIUT_PATH}/grub_menu.cfg"

  # Apply customization after menu list.
  tmp_filename="templates-custom/${FS_UUID}_grub_menu_footer.cfg"

  if [[ -e "${tmp_filename}" ]]; then

    cat "${tmp_filename}" >> "${GLIUT_PATH}/grub_menu.cfg"

  fi

  if [[ -r "${GLIUT_PATH}/lib/installed_os_enabled.cfg" ]]; then

    rm -v "${GLIUT_PATH}/lib/installed_os_enabled.cfg"

  fi

  for dir in "fedora" "ubuntu" "Microsoft"; do
    if [[ -d "${INPUT_PATH}/efi/${dir}" ]]; then

      cp -v "${GLIUT_PATH}/lib/installed_os.cfg" \
        "${GLIUT_PATH}/lib/installed_os_enabled.cfg"
      break

    fi
  done

  # TODO: add remaining conf parts here
}


update_gliut_destination() {

  mkdir -pv "${GLIUT_PATH}/tools"

  rsync \
    --recursive \
    --perms \
    --times \
    --exclude="fonts" \
    "gli_ut/" \
    "${GLIUT_PATH}"
  
  rsync \
    --recursive \
    --perms \
    --times \
    "grub_efi_bin/result/" \
    "${GLIUT_PATH}"
  
  rsync \
    --recursive \
    --perms \
    --times \
    --delete \
    "efi_shell/result/" \
    "${GLIUT_PATH}/tools/efi_shell"

  rsync \
    --recursive \
    --perms \
    --times \
    --delete \
    "passmark_memtest/result/" \
    "${GLIUT_PATH}/tools/passmark_memtest"

  rsync \
    --recursive \
    --perms \
    --times \
    --delete \
    "themes/${SELECTED_THEME}" \
    "${GLIUT_PATH}/themes"

  update_grub_menu
}


main() {

  # Simplistic argparse.
  #case $# in
  #  1)
  #    [[ -d "${1}" ]] || {
  #      err "Input directory does not exist"
  #      exit 1
  #    }
  #    INPUT_PATH="${1}"
  #    GLIUT_PATH="${INPUT_PATH}/efi/gli_ut"
  #    EFI_FALLBACK="${INPUT_PATH}/efi/boot"
  #    #readonly some_vars
  #    ;;
  #  *)
  #    usage
  #    ;;
  #esac

  FS_UUID="$(get_fs_uuid "${INPUT_PATH}")"
  readonly FS_UUID
  echo "${FS_UUID}"

  # We don't want to destroy valid boot loader configuration
  [[ -d "${EFI_FALLBACK}" ]] || create_efi_fallback

  [[ -d "${GLIUT_PATH}" ]] || mkdir -pv "${GLIUT_PATH}"

  update_gliut_destination

  [[ -d "${INPUT_PATH}/efi/iso" ]] || {
    mkdir -pv "${INPUT_PATH}/efi/iso"
    echo "GLI-UT was installed! Time to populate the efi/iso directory."
  }

  # TODO: offer to sync existing isos

}

main "$@"

