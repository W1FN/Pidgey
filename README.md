# W1FN Pidgey :bird: (Raspberry Pi APRS Digipeater)

A lightweight APRS Digipeater/iGate that runs in memory, with no writes to the SD card at runtime.
Specifically configured for the Twin State Radio Club (W1FN), but should be relatively easy to adapt for other usage.

## Usage

### Installation

You can image the SD card via `dd`, or whatever various imaging tool you like.

### Per-Device Configuration

All paths in this section are relative to the sdcard root.
The SD card is a FAT partition, so it should be editable on Linux/MacOS/Windows/etc.

- set the hostname in `/config/etc/hostname`
- add wireguard wg-quick config file(s) to `/config/etc/wireguard/{whatever}.conf`
- add SSH pubkey(s) to `/config/home/pidgey/.ssh/authorized_keys`
- if using wifi: add `/config/etc/wpa_supplicant.conf` generated by `wpa_passphrase`
- edit `/config.txt` to select the UDRC or DRAWS overlay
- add Dire Wolf config to `/config/etc/direwolf.conf`
- boot up the device and adjust audio levels
  - `setalsa-*.sh` scripts have some pre-made defaults from n7nix
  - if using `alsamixer`, remember to save these via `alsactl store`
  - `direwolf` can produce a level calibration tone when run with `-x` (ex `direwolf -c /etc/direwolf.conf -x`)

**If you edit files on the device at runtime, they will be lost unless copied to `/boot/config/`.**
**You can use the `persist` script for this purpose.**
**It will copy all files given on the command line, or check for changes to files in `/boot/config` if no arguments are passed.**

## Building

1. Either clone with `git clone --recurse-submodules` or after cloning run `git submodule update --init` to download buildroot.
2. `cd buildroot`
3. `make BR2_EXTERNAL=../br_external menuconfig` (or `xconfig`) and save the configuration
4. `make pidgey_defconfig` to select the config
5. `make`
6. flash `output/images/sdcard.img` to a sd card, and put it in a Raspberry Pi 3

## Acknowledgments/Sources

- [Buildroot](https://buildroot.org/)
- Based heavily on [naguirre/binky_buildroot](https://github.com/naguirre/binky_buildroot) and [romainreignier/minimal_raspberrypi_buildroot](https://github.com/romainreignier/minimal_raspberrypi_buildroot)
- direwolf/hamlib packages based on [markuslindenberg/aprspi](https://github.com/markuslindenberg/aprspi)
- UDRC/DRAWS specifics taken from [nwdigitalradio/n7nix](https://github.com/nwdigitalradio/n7nix)
- U-Boot/RAUC config bits from [cdsteinkuehler/br2rauc](https://github.com/cdsteinkuehler/br2rauc)
- Kernel config from [nerves-project/nerves_system_rpi3](https://github.com/nerves-project/nerves_system_rpi3)
