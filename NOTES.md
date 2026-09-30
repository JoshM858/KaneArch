# OrinsArch: Devlog / Notes

## Rename: Kane's Arch to OrinsArch

- Project renamed from "Kane's Arch" to **OrinsArch**, maintained by Orin Blackwel.
- `build-kanes-arch.sh` is now `build-orinsarch.sh`; the ISO is `orinsarch-*.iso`.
- Removed the joke claims (0 MB RAM, no GPU, "RAM-less Kernel", `pacman-cpu`,
  KaneWM). The project is a real Arch live image and the docs now say so.
- Build script fixes: fastfetch logo uses fastfetch's `$1`/`$2`/`$3` colour syntax,
  systemd-boot entries are branded too, `mkarchiso` gets its own work dir, and
  the profile.d script is given an executable entry in `file_permissions`.
- Added `EXTRA_PACKAGES` and `PROFILE_SRC` overrides.

## History

- **v2.0 "Kane Got ARCHed"**: public release as Kane's Arch.
- **v1.0 "The Big Bang"**: first private build.

## Known issues

- Boot menu branding is a find-and-replace and may need updating if `archiso`
  changes its config layout.
- Live/rescue image only: no graphical installer; use `archinstall`.

## Ideas

- Plymouth boot splash and wallpaper.
- Desktop-environment build.
- Theme `archinstall`.
