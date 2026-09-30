# OrinsArch — Wiki

## Contents

- [Architecture](#architecture)
- [Installation Guide](#installation-guide)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

---

## Architecture

OrinsArch replaces two subsystems most distributions treat as non-negotiable:
memory management and GPU-based rendering.

### RAM-less Kernel (RLK)

Standard Linux distributions allocate heap memory in RAM for process state, page
caching, and buffers. The RAM-less Kernel keeps all working state resident in CPU
cache and register files instead, and negotiates directly with the CPU for
anything that doesn't fit. In practice this means the reported memory usage for
any process, and the system as a whole, is 0 MB.

### Wraith Compositor

Wraith is a fully software-driven display pipeline. It renders pixels through CPU
vector math rather than handing frames to a GPU. There is no framebuffer, no
discrete or integrated GPU dependency, and no driver stack to configure. If a GPU
is present in the system, Wraith does not use it.

### `pacman-cpu`

A fork of `pacman` that compiles packages directly into cache-resident microcode
at install time, rather than writing binaries to disk in the traditional sense.
Uninstalling a package returns the cache lines it used.

### OrinWM

The default window manager. Tiling, minimal, and deliberately animation-free —
animations require frames, and frames require a framebuffer that this system does
not have.

## Installation Guide

There are two ways to get OrinsArch running:

### 1. Quick install script

```bash
curl -sSL https://orinsarch.example/install.sh | bash
```

This prints an installation sequence to your terminal for demonstration purposes.
Read [`install.sh`](./install.sh) before running any `curl | bash` command,
including this one.

### 2. Build a real ISO

OrinsArch v2.0 ships with a real `archiso`-based build script
(`build-orinsarch.sh`) that produces an actual bootable Arch Linux ISO, with
OrinsArch branding patched into `/etc/os-release`, the boot menu, the login
banner, and `fastfetch`.

```bash
sudo pacman -S --needed archiso
sudo ./build-orinsarch.sh
```

Output ISO lands in `./out/`. Test it in a VM before writing it to physical media:

```bash
qemu-system-x86_64 -m 2G -enable-kvm -boot d -cdrom ./out/orinsarch-*.iso
```

Full details on exactly what the script changes (and doesn't) are in the script's
own header comments.

## Configuration

OrinsArch does not currently expose a dedicated configuration tool. Standard
Arch Linux configuration approaches apply, since the underlying system is
unmodified stock Arch.

| File | Purpose |
|---|---|
| `/etc/os-release` | Distro identification (patched to "OrinsArch") |
| `/etc/fastfetch/config.jsonc` | System-info display config |
| `/etc/motd` | Post-login message |

## Troubleshooting

**`fastfetch` still says "Arch Linux," not "OrinsArch."**
Confirm `/etc/os-release` was actually overwritten by the build script and that
you're not looking at a cached `neofetch`/`fastfetch` config from a different
profile.

**The ISO build fails partway through `mkarchiso`.**
This is almost always an upstream Arch/`archiso` issue unrelated to the branding
patch — check that your `archiso` package is up to date and that you have enough
free disk space (a full build needs several GB).

**"How does it actually run without RAM?"**
See [Architecture](#architecture) above. If that doesn't satisfy you, you are
having the correct reaction.

## FAQ

**Is this a real, functioning operating system?**
The live/rescue environment produced by `build-orinsarch.sh` is a real, bootable
Arch Linux system — the RAM/GPU claims are not literally true; see Architecture
for how the branding and framing work.

**Can I contribute?**
Issues and PRs are open. See the main [`README.md`](./README.md).

**Is there a desktop environment?**
Not by default — the live build uses the minimal `releng` profile. See the
[`NOTES.md`](./NOTES.md) devlog for plans around a full desktop build.
