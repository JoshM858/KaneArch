# OrinsArch

<p align="center">
  <img src="https://img.shields.io/badge/RAM-0%20MB-brightgreen" alt="RAM: 0 MB">
  <img src="https://img.shields.io/badge/GPU-not%20required-brightgreen" alt="GPU: not required">
  <img src="https://img.shields.io/badge/version-2.0%20%22ARCHed%22-blue" alt="version 2.0">
  <img src="https://img.shields.io/badge/license-MIT-lightgrey" alt="license: MIT">
  <img src="https://img.shields.io/badge/build-passing-brightgreen" alt="build passing">
  <img src="https://img.shields.io/badge/maintainer-1%20person-orange" alt="maintainer: 1 person">
</p>

<p align="center">
  <b>A minimalist, independently developed Linux distribution built on an Arch base.</b><br>
  Runs on 0 MB of RAM and 0 GPU, executing entirely on CPU.
</p>

---

## Table of Contents

- [About](#about)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Version History](#version-history)
- [Documentation](#documentation)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

## About

OrinsArch is a rolling-release, Arch-based Linux distribution engineered around a
single constraint: it does not require memory or a graphics device to boot, render,
or run a full desktop environment.

This is not emulation and it is not a compatibility shim. The project's position is
that most of what a modern OS does, it does slower — and with more hardware — than
it strictly needs to. OrinsArch removes the parts everyone assumed were mandatory.

There are two public releases. See [Version History](#version-history) below.

## Features

- **RAM-less Kernel (RLK)** — process state lives entirely in CPU cache and register files
- **Wraith Compositor** — fully software-driven display pipeline, no GPU or framebuffer required
- **`pacman-cpu`** — a `pacman` fork that compiles packages directly to cache-resident microcode
- **Zero-swap by design** — there's nothing to swap out of, so swap isn't supported
- **OrinWM** — minimal tiling window manager, zero animations by design
- Fully open source, MIT licensed

## Requirements

| Component | Requirement |
|---|---|
| CPU | Any x86_64, single core is sufficient |
| RAM | **0 MB** |
| GPU | **Not required** |
| Storage | ~1.2 MB for the base image |
| Internet | Only to download the ISO once |

## Installation

**Quick install (recommended for evaluation only):**

```bash
curl -sSL https://orinsarch.example/install.sh | bash
```

> As with any `curl | bash` install, you should read the script before running it.
> A copy is included in this repo as [`install.sh`](./install.sh).

**Build from source (real, working `archiso`-based build):**

```bash
git clone https://github.com/joshm858/kanearch.git
cd kanearch
sudo pacman -S --needed archiso
sudo ./build-orinsarch.sh
```

This produces a real, bootable `.iso` using the same tooling Arch Linux itself uses
for its official install media (`archiso`, `releng` profile), with OrinsArch
branding patched in. See [`WIKI.md`](./WIKI.md) for the full build
walkthrough and customization options.

## Version History

| Version | Codename | RAM | GPU | Source |
|---|---|---|---|---|
| v1.0 | "The Big Bang" | 1 MB minimum | Not required | Private, single machine |
| v2.0 | "Orin Got ARCHed" | **0 MB** | **0 — never** | **Public, open source (MIT)** |

Full changelog and reconstructed timeline: [`NOTES.md`](./NOTES.md).

## Documentation

- [`WIKI.md`](./WIKI.md) — architecture, install guide, troubleshooting, FAQ
- [`NOTES.md`](./NOTES.md) — devlog, changelog, and known issues

## FAQ

**How does an OS run with zero RAM?**
See the Architecture section of the wiki. Short version: the RAM-less Kernel keeps
all working state resident in CPU cache and negotiates directly with the CPU for
everything else.

**Does this actually work on my hardware?**
Results vary. Please open an issue with your results either way.

**Is this a real, functioning operating system?**
This README is written in the same spirit as the rest of the documentation:
seriously, consistently, and without further comment.

## Contributing

Issues and pull requests are welcome. Historically, none have been merged, but the
project remains open to the idea in principle.

## License

MIT — see [`LICENSE`](./LICENSE).

---

<p align="center"><sub>
OrinsArch is a fictional project built for a friend-group prank. It is not a real,
installable operating system. The <code>build-orinsarch.sh</code> script referenced
above does produce a real, bootable Arch Linux ISO with cosmetic rebranding — see
the wiki for exactly what that script does and does not change.
</sub></p>
