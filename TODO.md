- https://github.com/mateosss/matter
- kali linux
- Create iso_fedora.cfg
- Ventoy: https://github.com/ventoy/Ventoy
- fedora grubcd.efi is another option, some people might recommend you to get cygwin/msys or some other poorly maintained build, but I can't recommend doing this while there are plenty of other options available.
- `tree` output on the drive
- create `create.sh` for grub_efi_bin (actually build.sh, since ventoy does that and it sounds ok)
- `rd.live.ram=1` via https://ask.fedoraproject.org/t/booting-a-liveos-image-fully-into-ram/20788
- gli_ut/lib/iso_ubuntu.cfg: add more flavors

TODO:

- [f] check book for multi boot disk approach
- book: read p.167 about secure boot scope

---
# Fedora ISO filename

- FAQ: https://ask.fedoraproject.org/t/what-does-the-last-part-in-fedora-workstation-live-x86-64-37-1-7-iso-stand-for-the-1-7/30379

# BLSCFG

- https://fedora.pkgs.org/37/fedora-x86_64/grub2-common-2.06-58.fc37.noarch.rpm.html - translations
- https://fedora.pkgs.org/37/fedora-x86_64/grub2-efi-x64-modules-2.06-58.fc37.noarch.rpm.html - blscfg.mod butr also zfs.mod
- https://fedora.pkgs.org/37/fedora-x86_64/grub2-efi-x64-cdboot-2.06-58.fc37.x86_64.rpm.html - font
- https://fedora.pkgs.org/37/fedora-x86_64/grub2-tools-2.06-58.fc37.x86_64.rpm.html - configuration files

# READING list

- Distros on https://github.com/ventoy/Ventoy
  - https://docs.zfsbootmenu.org/en/latest/
- https://fedoraproject.org/wiki/LiveOS_image
- Ventoy: https://github.com/ventoy/Ventoy
  - https://www.ventoy.net/en/doc_browser.html
  - https://www.ventoy.net/en/doc_start.html
  - https://www.ventoy.net/en/doc_secure.html
