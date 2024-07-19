$(call PKG_INIT_BIN, 0.0.1)
$(PKG)_SOURCE:=vlmcsdsetup-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=eef58b0db16801358f0aeb37a9c3bf4f5caf0f8afc2ccb4b0ba3fd8307a9ab69
$(PKG)_SITE:=@SF/VLMCSDSETUP
$(PKG)_BINARY:=$($(PKG)_DIR)/vlmcsdsetup
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/vlmcsdsetup

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(VLMCSDSETUP_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(VLMCSDSETUP_DIR) clean
	$(RM) $(VLMCSDSETUP_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(VLMCSDSETUP_TARGET_BINARY)

$(PKG_FINISH)
