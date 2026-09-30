# OrinsArch

A branded, Arch Linux-based live/rescue ISO, maintained by **Orin Blackwel**.

OrinsArch is built with the official [`archiso`](https://wiki.archlinux.org/title/Archiso)
`releng` profile. The kernel, packages and install process are stock Arch Linux.
OrinsArch adds its own branding (`os-release`, login banner, `fastfetch` screen,
boot menu entries) and a few extra packages.

## Requirements

**To build:** an Arch Linux machine (or container) with root access, the `archiso`
package, and several GB of free disk space and an internet connection.

**To run the ISO:** any x86_64 machine or VM. Use at least 2 GB of RAM for the
live environment, as it runs from memory.

## Build

```bash
git clone https://github.com/joshm858/kanearch.git
cd kanearch
sudo pacman -S --needed archiso
sudo ./build-orinsarch.sh
```

The ISO is written to `./out/orinsarch-*.iso`. Add packages with:

```bash
sudo EXTRA_PACKAGES="git vim htop" ./build-orinsarch.sh
```

## Try it

```bash
qemu-system-x86_64 -m 2G -enable-kvm -boot d -cdrom out/orinsarch-*.iso
```

To write it to a USB drive (this destroys the drive's contents; check `/dev/sdX`):

```bash
sudo dd if=out/orinsarch-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## Installing to disk

The ISO is a live/rescue image and has no dedicated installer. Use `archinstall`
from the live shell, or follow the
[Arch installation guide](https://wiki.archlinux.org/title/Installation_guide).

## Documentation

- [`WIKI.md`](./WIKI.md): what the build changes, configuration, troubleshooting
- [`NOTES.md`](./NOTES.md): devlog, history and known issues

## History

The project started as "Kane's Arch" and was renamed OrinsArch. See
[`NOTES.md`](./NOTES.md).

## License

MIT
