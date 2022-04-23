# W1FN Pidgey :bird: (Raspberry Pi APRS Digipeater)

A lightweight APRS Digipeater/iGate that runs in memory, with no writes to the SD card at runtime.
Specifically configured for the Twin State Radio Club (W1FN), but should be relatively easy to adapt for other usage.

## Usage/Building

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
