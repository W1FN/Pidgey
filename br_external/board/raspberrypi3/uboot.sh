test -n "${BOOT_ORDER}" || setenv BOOT_ORDER "A B"
test -n "${BOOT_A_LEFT}" || setenv BOOT_A_LEFT 3
test -n "${BOOT_B_LEFT}" || setenv BOOT_B_LEFT 3

# RPi firmware uses a dynamic fdt_addr, but U-Boot does not use the fw
# provided address if fdt_addr is already defined in the environment!
# Copy fdt_addr to a local variable and delete the environment variable
# so it never gets accidentally saved:
fdt_addr=${fdt_addr}
env delete fdt_addr

# Get bootargs from firmware fdt
fdt addr ${fdt_addr}
fdt get value bootargs_fw /chosen bootargs
# store in a local variable, but do not persist
bootargs_fw=${bootargs_fw}
env del bootargs_fw

setenv bootargs
for BOOT_SLOT in "${BOOT_ORDER}"; do
  if test "x${bootargs}" != "x"; then
    # skip remaining slots
  elif test "x${BOOT_SLOT}" = "xA"; then
    if test ${BOOT_A_LEFT} -gt 0; then
      echo "Found valid slot A, ${BOOT_A_LEFT} attempts remaining"
      setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1
      setenv load_kernel "fatload mmc 0:1 ${kernel_addr_r} zImage.A"
      setenv bootargs "${bootargs_fw} rauc.slot=A"
    fi
  elif test "x${BOOT_SLOT}" = "xB"; then
    if test ${BOOT_B_LEFT} -gt 0; then
      echo "Found valid slot B, ${BOOT_B_LEFT} attempts remaining"
      setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1
      setenv load_kernel "fatload mmc 0:1 ${kernel_addr_r} zImage.B"
      setenv bootargs "${bootargs_fw} rauc.slot=B"
    fi
  fi
done

if test -n "${bootargs}"; then
  saveenv
else
  echo "No valid slot found, resetting tries to 3"
  setenv BOOT_A_LEFT 3
  setenv BOOT_B_LEFT 3
  saveenv
  reset
fi

echo "Loading kernel"
run load_kernel
echo " Starting kernel"
bootz ${kernel_addr_r} - ${fdt_addr}
