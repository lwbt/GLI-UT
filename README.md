# GLI-UT – GRUB2 Live ISO & UEFI Toolbox

Sets up a toolbox to boot Live ISOs and manage content on EFI System Partitions

Upstream: https://github.com/lwbt/GLI-UT

[[_TOC_]]

The name sound awful. But it is unlikely to collide with other projects. And I
spent too much time already thinking about a name for a project I only want to
use for myself and the few people who cared enough to give me +1 on
Stackoverflow.


## What is different to other projects of this kind?

- Functions! I basically understood how to make use of functios in GRUB
  scripting to avoid writing the same thing over and over. Programming 101
  indeed.
- Also not a new break through anymore: Using boot loader images as standalone
  binaries. No root permissions required, no installation and meddling with
  partitions required. Continued in [FAQ](./FAQ.md).


## Inspiration and heritage

- GLIM: Looked clever, but I couldn't get it to work tailored to my needs.
- *Yogesh Babar: Hands on Booting* (contains the Jarvis boot project) ISBN
  978-1-4842-5890-3
- Rufus: It took me a while to acknowledge the value of this tool among so
  many other similar tools and particularly how the author did it.
  https://github.com/pbatard/rufus/wiki/FAQ
- [My post on AskUbuntu](https://askubuntu.com/a/395880) and many more posts
  involved with booting and adoption of UEFI, but my lack of experience and
  knowledge led to a monolithic and pooly maintained grub.cfg.
- [Roderick W. Smith](https://www.rodsbooks.com/)


## Useful links and resources

- Some people are calling it GRUB script or GRUB scripting, it looks similar to
  BASH with coreutils, but be careful!
  https://www.gnu.org/software/grub/manual/grub/html_node/Shell_002dlike-scripting.html


## Debugging

- `set` shows all set variables on the GRUB console, access it byu pressing `c`
  in the menu. You'll find variables like achitecture (`grub_cpu`) and
  `package_version` there.
- Example for adding an entry to the system boot list from Linux:
  `sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L Toolbox -l \\EFI\\gli_ut\\bootx64.efi`
- Check configuration code with grub:
  `grub-script-check $file_name`
