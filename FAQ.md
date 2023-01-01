# FAQ – Frequently asked Questions

[[_TOC_]]


## General

### What is different to other projects of this kind?

Note: This is a 1:1 copy from the [README.md](./README.md).

- Functions! I basically understood how to make use of functios in GRUB
  scripting to avoid writing the same thing over and over. Programming 101
  indeed.
- Also not a new break through anymore: Using boot loader images as standalone
  binaries. No root permissions required, no installation and meddling with
  partitions required. Continued in FAQ.


### Why do you not use GLIM?

I mentioned it in the README, but including it there was too long and
distracting, so here we go:

- Use of `regexp` looked fancy, until hours later of wrangling with it, it
  still did not work and simply just using the plain string was good enough.
- Use of `for` looked genius, but didn't work reliably or predicatably at all.
  It's also not a recommended or safe usage of `for`, but we can't use
  `find ... | xargs` in GRUB either.
- I had my own theme, I prefer monochrome which is where the industry seemed to
  have moved again, loading and maintaining a lot of assests was more of a
  burden.


### Why not support legacy PC booting?

- It's cumbersome and I prefer to just push files to a drive or partition
  adhering to [principle of least
  privilege.](https://en.wikipedia.org/wiki/Principle_of_least_privilege)
- [Legacy BIOS support is almost
  dead](https://en.wikipedia.org/w/index.php?title=BIOS&oldid=1128644915#Alternatives_and_successors)
  - [Intel Technical Advisory
    630266](https://cdrdv2.intel.com/v1/dl/getContent/630266?wapkw=630266)
  - https://www.anandtech.com/show/12068/intel-to-remove-bios-support-from-uefi-by-2020


### Can I use this on my EFI System Partition as an emergency toolbox?

Yes! Absolutely. Read the section above. Yes I also use and maintain this
project for this reason.


## So, a giant GO binary for terminal eyecandy?

My decision. There have been other tools in the community with GUIs which where
quite contradictory with regards to boot issues. but I digress. Yes, I will try
to get the most basic things done with the least but concise and safe shell
code as possible. For additional features and usability I will use GUM.  You
either have it already and see value in it, or you don't like it, which is fine
with me. The basic fucntionality is important, everything else should really
not be written anymore in shell from my poit of view for my own sanity and
quality of life. Disagree, fork, or do whatever you prefer as long as it is
civilised and constructive.


## Ubuntu, Fedora, or what distro do you prefer?

While it all started with Ubuntu for me and Ubuntu is still my daily driver,
Fedora includes BLSCFG and ZFS, so I would go with the one that provides the
greatest compatbility, which seems to be Fedora.


## Installation

### I need to create GRUB EFI images? How do I create them?

Isn't this a chicken and egg problem? Not by todays standards, if you have
absolutely no Linux around then you should be able to run the script from WSL,
Crostini or some other Linux Container. I need to make sure by myself that the
process is straight forward through. No you should not need to meddle with the
boot manager of the particular system as we only need to assemble precompiled
binaries into a larger one.


### How do I perform the Instalaltion, and why so many scripts?

Think of this as a monorepo for scripts, ideas and things I mostly did by hand
over the years because I thought others can write much better scripts or
application code. Now I want to have all of this in one public repository
because browsing the web for all the litte parts turned out to be more time
consuming than I thought.

Scripts you can run before run.sh:

- TODO: list here

Scripts you must run before run.sh:

- TODO: grub_efi_bin/build.sh

And yes, this repository also serves as my knowledgebase.


### Why do I have to download all the things by myself?

A request will probably come up to publish some lazy "Ultimate Edition". In
other words: piracy and shallow script kiddy knowledge approaches.

Here is my point of view:

- Many of the tools are free.
- I respect the licenses of the individual software projects and components for
  *personal use*.
- Some licenses may be incompatible or may change over time. No big deal for
  end users who don't read license agreements anyways in most cases, but a big
  problem for redistributors.
- I don't want to be your redistributor, single point of contact or any such
  thing for people who can't and won't read just a few lines of code.
- Git is a source code management tool, it can handle large files (blobs), but
  I really like tiny repositories and keeping things simple. Setup your own
  artifact or blob store if you want, there is lots to be learned about
  archival and content distribution, but it's beyond the scope of this project.


### How should the drive or partition be named? What are the usage secnarios?

- The choice of naming is up to you. `OEMDRIVE` and `CIDATA` have some
  benefits, or should only be used where appropriate.
  - [Red Hat - Kickstart](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/performing_an_advanced_rhel_9_installation/making-kickstart-files-available-to-the-installation-program_installing-rhel-as-an-experienced-user#making-a-kickstart-file-available-on-a-local-volume-for-automatic-loading_making-kickstart-files-available-to-the-installation-program)
  - [CloudInit](https://cloudinit.readthedocs.io/en/21.3/topics/datasources/nocloud.html)
- Aside from creating bootable external media, having more space on your EFI
  System Partition for tools and recovery media available for troubleshooting
  is probably the best way to be prepared for worst case secenarios and enjoying
  general purpose computer systems. 50 MB use out of 500 MB feel like wasted
  space for some, having your OS as Live Media and a few other tools available
  with more to come doesn't feel like waste anymore but well prepared.

Scope:

- It is not inteded to support every possible distribution and tool or legacy
  boot mode. A small and versatile toolkit with minimal overhead is intended.
  Jarvis with 100+ instalaltions took almost an hour to detect every installed
  operating system, which is a remarkable achivement, but not useful for me at
  all. Thus mos of the configuration is hard coded and stripped down to the
  minimum.


### My EFI partition isn't that big to hold such media, your thinking is flawed.

Then make the partition bigger the next time you install your favorite Linux or
put the files on another partition. I need to write a bit of customization
logic to make that work but you just need to change the device and be able to
read the partition (whoops it might be encrypted). I won't let the argument
count that there is nothing that can be done about installation procedures and
that creating partition layouts is cumbersome. Kickstart and other mechanisms
exist. Customize once, look at the gerated data and apply to a new
installation. Done!


### What kind of drive should I use?

Use any off-the-shelf FAT formatted SD card or USB memory stick.  FAT32 might
work better than more common exFAT media found on larger storage media these
days, but formatting and creating partitions shouldn't be too difficult when
you are reading this here. Creating partitions under Linux for such devices
whould be easier, but Rufus can also help you with that and even allow you to
use NTFS, which is not in the standard but the reasoning of the author looks
solid and it works, so have fun!


## About images, ISOs and operating systems

### Adding persistence to live media

Depends on distribution:

- Ubuntu:
  - `home-rw`: For the home directory. This makes the most sense, updating the
    entire filesytem not so much, thus when this file is present at the root of
    the filesystem the respective launch option will be shown.
  - `casper-rw`: The more well known option, which apparently does not work for
    home on modern versions of Ubuntu. If the file is present at the root of
    the filesystem, then it will be used, but the respective launch option will
    not be shown when `home-rw` is not present.
- Kali Linux: Not implemented, I prefer using files like on Ubuntu, instead of
  creating more partitions.


## Theming

### Why use a theme at all?

Using a minimal theme and the GFX terminal resulted in faster reaction and
refresh times or general overall performance and on some machines with high
resolution displays in the past. May be that has been fixed or I need to do
more research on why that happens and when. A minimal theme is also consistent
accross different GRUB images, although I have preferred Fedoras patched
no-frill menu and would recreate something like that or sd-boot if I could. At
last there may be the possibility to also implement different screen
orientations if needed, like for example on Steam Deck, but I don't know how to
do that yet.


### Alternative themes

Are not supported yet.

Some interesting alternatives I found so far:

- https://github.com/mateosss/matter


## Coding guidelines and style

- Apply Shellcheck to BASH scripts
- Apply Google Shell Style Guide to BASH scripts
- The above don't completely apply to GRUB scripting
