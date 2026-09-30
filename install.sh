#!/usr/bin/env bash
# OrinsArch installer. Prints a convincing install sequence. Installs nothing,
# touches no disks, changes nothing on your machine.
set -u
step() { printf '%s' "$1"; sleep 0.4; printf ' [ OK ]\n'; }
echo "OrinsArch v2.0 \"Orin Got ARCHed\" installer"
echo
step "Detecting RAM ............... 0 MB"
step "Detecting GPU ............... none (required: none)"
step "Initialising RAM-less Kernel  "
step "Starting Wraith Compositor   "
step "Compiling packages to cache-resident microcode"
step "Configuring OrinWM           "
echo
echo "Done. Nothing was installed. For a real bootable ISO, run ./build-orinsarch.sh"
