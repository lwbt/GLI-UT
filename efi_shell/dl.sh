#!/bin/bash

dl_arch=( "X64" "Ia32" "Arm" "AArch64" )
efi_arch=( "x64" "ia32" "arm" "aa64" )

mkdir "result/"

# Full EFI shell v1 required for certain firmware updates.
base_url="https://github.com/tianocore/edk2-archive/raw/master/EdkShellBinPkg/FullShell/"

# Count items in $dl_arch and loop over them.
for i in $(seq 0 $((${#dl_arch[@]}-1))); do

  wget -O "result/shell_fullv1_${efi_arch[$i]}.efi" \
    "${base_url}${dl_arch[$i]}/Shell_Full.efi"

done


# Current and actively maintained EFI shell.
base_url="https://github.com/tianocore/edk2/raw/UDK2018/ShellBinPkg/UefiShell/"

for i in $(seq 0 $((${#dl_arch[@]}-1))); do

  wget -O "result/shell${efi_arch[$i]}.efi" \
    "${base_url}${dl_arch[$i]}/Shell.efi"

done
