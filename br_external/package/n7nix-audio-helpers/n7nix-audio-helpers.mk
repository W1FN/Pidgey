################################################################################
#
# n7nix-audio-helpers
#
################################################################################

N7NIX_AUDIO_HELPERS_VERSION = 966584db131d2576c7d4f50f995eaf00229b6a36
N7NIX_AUDIO_HELPERS_SITE = https://github.com/nwdigitalradio/n7nix
N7NIX_AUDIO_HELPERS_SITE_METHOD = git

define N7NIX_AUDIO_HELPERS_INSTALL_TARGET_CMDS
# Disable check for asound state file
	sed -i '/^asoundstate_file/d;/stateowner=$$(stat/,/^fi$$/d' $(@D)/bin/setalsa-*.sh
	$(INSTALL) -D -m 0755 $(@D)/bin/udrcver.sh $(@D)/bin/setalsa-*.sh $(@D)/bin/alsa-show.sh $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))

