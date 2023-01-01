# How to create the boot$ARCH.efi images with GRUB

## Which version to choose?

These images have been build on recent versions from Ubuntu 20.10 for all
architectures.  I will try to update these whenever a Ubuntu LTS release has
been published.


## Install ARM packages on x64

You can isntall the these packages without any risk, they only add modules and
achitectures to GRUB so we can source them later to build ARM and ARM64 iamges.

```bash
file="grub-efi-arm64-bin_2.04-1ubuntu35.4_arm64.deb"
wget "http://ports.ubuntu.com/pool/main/g/grub2/${file}"
sudo dpkg -i --force-architecture "${file}"

file="grub-efi-arm-bin_2.04-1ubuntu35.4_armhf.deb"
wget "http://ports.ubuntu.com/pool/main/g/grub2/${file}"
sudo dpkg -i --force-architecture "${file}"
```


## Building images

Create a temporary configuration as explained in the [Arch Linux
Wiki](https://wiki.archlinux.org/index.php/GRUB/Tips_and_tricks#GRUB_standalone).

```bash
echo 'configfile ${cmdpath}/grub.cfg' > /tmp/grub.cfg
```

For AMD64:

```bash
image="bootx64.efi"; grub_arch="x86_64-efi"; \
grub-mkstandalone -v -o "${image}" -O "${grub_arch}" --locales="en@quot" \
--themes="" --modules="part_gpt part_msdos png" "boot/grub/grub.cfg=/tmp/grub.cfg"
```

For AMD64, with all modules:

```bash
image="bootx64.efi"; grub_arch="x86_64-efi"; \
grub-mkstandalone -v -o "${image}" -O "${grub_arch}" \
--locales="en@quot" \
--themes="" \
--modules="$(find /usr/lib/grub/${grub_arch}/ -name "*.mod" \
             | xargs basename -s ".mod")" \
"boot/grub/grub.cfg=/tmp/grub.cfg"
```

For i386:

```bash
image="bootia32.efi"; grub_arch="i386-efi"; \
grub-mkstandalone -v -o "${image}" -O "${grub_arch}" --locales="en@quot" \
--themes="" --modules="part_gpt part_msdos png" "boot/grub/grub.cfg=/tmp/grub.cfg"
```

For ARM64:

```bash
image="bootaa64.efi"; grub_arch="arm64-efi"; \
grub-mkstandalone -v -o "${image}" -O "${grub_arch}" --locales="en@quot" \
--themes="" --modules="part_gpt part_msdos png" "boot/grub/grub.cfg=/tmp/grub.cfg"
```

For ARM:

```bash
image="bootarm.efi"; grub_arch="arm-efi"; \
grub-mkstandalone -v -o "${image}" -O "${grub_arch}" --locales="en@quot" \
--themes="" --modules="part_gpt part_msdos png" "boot/grub/grub.cfg=/tmp/grub.cfg"
```
