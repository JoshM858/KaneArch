# OrinsArch Wiki

## Contents

- [What it is](#what-it-is)
- [Building](#building)
- [What the build changes](#what-the-build-changes)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

## What it is

OrinsArch is a live/rescue ISO produced from the official Arch Linux `releng`
archiso profile by `build-orinsarch.sh`. Everything not listed under
[What the build changes](#what-the-build-changes) is unmodified Arch.

## Building

Run on Arch Linux as root:

```bash
sudo pacman -S --needed archiso
sudo ./build-orinsarch.sh
```

Output lands in `./out/`. Build times depend on your connection because the full
package set is downloaded. A build needs several GB of free disk space.

Test in a VM before writing to physical media:

```bash
qemu-system-x86_64 -m 2G -enable-kvm -boot d -cdrom ./out/orinsarch-*.iso
```

Set `EXTRA_PACKAGES` to add packages to the image, and `PROFILE_SRC` to build from
a different archiso profile.

## What the build changes

| Area | Change |
|---|---|
| `profiledef.sh` | ISO name `orinsarch`, label, publisher (Orin Blackwel), application |
| `/etc/os-release`, `/etc/lsb-release` | Identify the system as OrinsArch (`ID_LIKE=arch`) |
| `/etc/issue`, `/etc/motd` | Login banner and welcome message |
| `fastfetch` | Custom logo and config, run on interactive login shells |
| Boot menus | "Arch Linux" becomes "OrinsArch" in syslinux, GRUB and systemd-boot entries |
| `packages.x86_64` | Adds `fastfetch` plus anything in `EXTRA_PACKAGES` |

## Configuration

There is no OrinsArch-specific configuration tool; standard Arch configuration
applies.

| File | Purpose |
|---|---|
| `/etc/os-release` | Distro identification |
| `/etc/fastfetch/config.jsonc` | System-info display |
| `/etc/motd` | Post-login message |

## Troubleshooting

**`fastfetch` shows "Arch Linux".**
Check that `/etc/os-release` inside the live system says OrinsArch, and that you
are not reading a user-level `~/.config/fastfetch` override.

**The ISO build fails partway through `mkarchiso`.**
Usually an upstream Arch or `archiso` issue. Update `archiso`, check free disk
space and network access, then rerun.

**A boot menu still says "Arch Linux".**
The label patch is a find-and-replace over the syslinux, GRUB and systemd-boot
configs. If a new `archiso` release moves those files, update step 7 of the script.

## FAQ

**Is this a real operating system?**
It is a real, bootable Arch Linux live/rescue image with OrinsArch branding.

**Is there a graphical installer or desktop?**
Not yet. The image is TTY-based; install with `archinstall`.

**Can I contribute?**
Yes, open an issue or pull request.
