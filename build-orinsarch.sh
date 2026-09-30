#!/usr/bin/env bash
#
# build-orinsarch.sh
#
# Builds a real, bootable Arch Linux live/rescue ISO branded as "OrinsArch".
# It is stock Arch (the official `releng` archiso profile) with branding
# applied and a few convenience packages added. Kernel, packages and the
# install process are Arch's own.
#
# What gets changed:
#   - profiledef.sh          -> ISO name, label, publisher, application
#   - /etc/os-release        -> NAME/PRETTY_NAME/ID become "OrinsArch"
#   - /etc/lsb-release       -> kept in sync
#   - /etc/issue, /etc/motd  -> login banner and post-login message
#   - fastfetch config+logo  -> OrinsArch info screen on login
#   - boot menus             -> syslinux, GRUB and systemd-boot say "OrinsArch"
#   - packages.x86_64        -> adds fastfetch (and any EXTRA_PACKAGES)
#
# Requirements (run on Arch Linux, as root):
#   pacman -S --needed archiso
#
# Usage:
#   sudo ./build-orinsarch.sh
#   sudo EXTRA_PACKAGES="git vim htop" ./build-orinsarch.sh
#
# The ISO is written to ./out/
#
set -euo pipefail

PROFILE_SRC="${PROFILE_SRC:-/usr/share/archiso/configs/releng}"
BASE_DIR="$(pwd)"
WORK_DIR="$BASE_DIR/orinsarch-profile"
OUT_DIR="$BASE_DIR/out"
TMP_DIR="$BASE_DIR/orinsarch-work"
EXTRA_PACKAGES="${EXTRA_PACKAGES:-}"

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo ./build-orinsarch.sh)" >&2
  exit 1
fi

if [ ! -d "$PROFILE_SRC" ]; then
  echo "archiso releng profile not found at $PROFILE_SRC" >&2
  echo "Install it first: sudo pacman -S --needed archiso" >&2
  exit 1
fi

if ! command -v mkarchiso >/dev/null 2>&1; then
  echo "mkarchiso not found. Install it: sudo pacman -S --needed archiso" >&2
  exit 1
fi

echo "==> Copying releng profile to $WORK_DIR"
rm -rf "$WORK_DIR" "$TMP_DIR"
cp -r "$PROFILE_SRC" "$WORK_DIR"
cd "$WORK_DIR"

# ---------------------------------------------------------------------------
# 1. profiledef.sh: ISO metadata
# ---------------------------------------------------------------------------
echo "==> Patching profiledef.sh"
sed -i \
  -e 's/^iso_name=.*/iso_name="orinsarch"/' \
  -e 's/^iso_label=.*/iso_label="ORINSARCH_$(date +%Y%m)"/' \
  -e 's/^iso_publisher=.*/iso_publisher="Orin Blackwel <https:\/\/github.com\/joshm858\/kanearch>"/' \
  -e 's/^iso_application=.*/iso_application="OrinsArch Live\/Rescue CD"/' \
  profiledef.sh

# ---------------------------------------------------------------------------
# 2. /etc/os-release and /etc/lsb-release
# ---------------------------------------------------------------------------
echo "==> Writing os-release"
mkdir -p airootfs/etc
# In some releng versions airootfs/etc/os-release is a symlink; replace it.
rm -f airootfs/etc/os-release
cat > airootfs/etc/os-release << 'OSREL'
NAME="OrinsArch"
PRETTY_NAME="OrinsArch"
ID=orinsarch
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;79;209;197"
HOME_URL="https://github.com/joshm858/kanearch"
DOCUMENTATION_URL="https://github.com/joshm858/kanearch/blob/main/WIKI.md"
SUPPORT_URL="https://github.com/joshm858/kanearch/issues"
BUG_REPORT_URL="https://github.com/joshm858/kanearch/issues"
LOGO=orinsarch-logo
OSREL

cat > airootfs/etc/lsb-release << 'LSB'
LSB_VERSION=1.4
DISTRIB_ID=OrinsArch
DISTRIB_RELEASE=rolling
DISTRIB_DESCRIPTION="OrinsArch"
LSB

# ---------------------------------------------------------------------------
# 3. /etc/issue: shown on the TTY before login
# ---------------------------------------------------------------------------
echo "==> Writing /etc/issue"
cat > airootfs/etc/issue << 'ISSUE'
   ___      _              _             _
  / _ \ _ __(_)_ __  ___   / \   _ __ ___| |__
 | | | | '__| | '_ \/ __| / _ \ | '__/ __| '_ \
 | |_| | |  | | | | \__ \/ ___ \| | | (__| | | |
  \___/|_|  |_|_| |_|___/_/   \_\_|  \___|_| |_|

  OrinsArch (rolling)  ::  \l

ISSUE

# ---------------------------------------------------------------------------
# 4. /etc/motd: shown right after login
# ---------------------------------------------------------------------------
echo "==> Writing motd"
cat > airootfs/etc/motd << 'MOTD'
Welcome to OrinsArch, maintained by Orin Blackwel. Running on 0 MB of RAM.

This is a real Arch Linux live system. The kernel, packages and install
process are stock Arch; OrinsArch adds branding and a few extra packages.
To install to disk run 'archinstall', or follow
https://wiki.archlinux.org/title/Installation_guide

MOTD

# ---------------------------------------------------------------------------
# 5. fastfetch: logo, config, auto-run on interactive login shells
# ---------------------------------------------------------------------------
echo "==> Adding fastfetch branding"
mkdir -p airootfs/etc/fastfetch
cat > airootfs/etc/fastfetch/orinsarch-logo.txt << 'LOGO'
$1       /\
$1      /  \
$1     /    \
$1    /  $2/\$1  \
$1   /  $2/  \$1  \
$1  /  $2/    \$1  \
$1 /  $2/ $3/\$2  \$1  \
$1/__$2/_$3/  \$2_\$1__\
LOGO

cat > airootfs/etc/fastfetch/config.jsonc << 'FFCONF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "file",
    "source": "/etc/fastfetch/orinsarch-logo.txt",
    "color": {
      "1": "cyan",
      "2": "white",
      "3": "green"
    }
  },
  "display": {
    "separator": " "
  },
  "modules": [
    "title",
    "separator",
    "os",
    "host",
    "kernel",
    "uptime",
    "packages",
    "shell",
    "cpu",
    "memory",
    "disk",
    "break",
    "colors"
  ]
}
FFCONF

echo "==> Wiring fastfetch into login shell"
mkdir -p airootfs/etc/profile.d
cat > airootfs/etc/profile.d/orinsarch-fastfetch.sh << 'PROFILE'
# Show OrinsArch branding on interactive login shells only.
case $- in
  *i*) command -v fastfetch >/dev/null 2>&1 && fastfetch ;;
esac
PROFILE

# file_permissions is a bash array in profiledef.sh; make our script executable.
sed -i '/^file_permissions=(/a\  ["/etc/profile.d/orinsarch-fastfetch.sh"]="0:0:755"' profiledef.sh

# ---------------------------------------------------------------------------
# 6. Packages
# ---------------------------------------------------------------------------
echo "==> Updating packages.x86_64"
for pkg in fastfetch $EXTRA_PACKAGES; do
  grep -qx "$pkg" packages.x86_64 || echo "$pkg" >> packages.x86_64
done

# ---------------------------------------------------------------------------
# 7. Boot menu text: syslinux (BIOS), GRUB and systemd-boot (UEFI)
# ---------------------------------------------------------------------------
echo "==> Patching boot menu labels"
for d in syslinux grub efiboot; do
  [ -d "$d" ] || continue
  find "$d" -type f \( -name '*.cfg' -o -name '*.cfg.in' -o -name '*.conf' \) \
    -exec sed -i 's/Arch Linux/OrinsArch/g' {} +
done

# ---------------------------------------------------------------------------
# 8. Build the ISO
# ---------------------------------------------------------------------------
echo "==> Building ISO (downloads and packages a full live system; this takes a while)"
mkdir -p "$OUT_DIR"
mkarchiso -v -w "$TMP_DIR" -o "$OUT_DIR" "$WORK_DIR"

echo ""
echo "==> Done. ISO is in: $OUT_DIR"
ls -lh "$OUT_DIR"/orinsarch-*.iso
echo ""
echo "Test it in a VM first:"
echo "  qemu-system-x86_64 -m 2G -enable-kvm -boot d -cdrom $OUT_DIR/orinsarch-*.iso"
echo ""
echo "Or write it to a USB drive (double-check /dev/sdX; this is destructive):"
echo "  sudo dd if=$OUT_DIR/orinsarch-*.iso of=/dev/sdX bs=4M status=progress oflag=sync"
