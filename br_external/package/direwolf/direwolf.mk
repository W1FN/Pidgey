################################################################################
#
# direwolf
#
################################################################################

DIREWOLF_VERSION = 1.6
DIREWOLF_SITE = https://github.com/wb2osz/direwolf.git
DIREWOLF_SITE_METHOD = git
DIREWOLF_CONF_OPTS = -Wno-dev -DRUN_NEON=$(if $(BR2_ARM_CPU_HAS_NEON),0,1)
DIREWOLF_DEPENDENCIES = alsa-lib \
	$(if $(BR2_PACKAGE_HAMLIB),hamlib) \
	$(if $(BR2_PACKAGE_GPSD),gpsd) \
	$(if $(BR2_PACKAGE_LIBGPIOD),libgpiod)

define DIREWOLF_USERS
	direwolf -1 direwolf -1 * - - dialout,gpio,audio Direwolf TNC
endef

define DIREWOLF_INSTALL_CONFIG
	$(INSTALL) -D -m 0644 $(DIREWOLF_PKGDIR)/direwolf.conf \
		$(TARGET_DIR)/etc/direwolf.conf
endef

DIREWOLF_POST_INSTALL_TARGET_HOOKS += DIREWOLF_INSTALL_CONFIG

$(eval $(cmake-package))
