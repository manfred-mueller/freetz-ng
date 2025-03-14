$(call PKG_INIT_BIN, 20150613)
$(PKG)_SOURCE_DOWNLOAD_NAME:=$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=141cad384dc42f094d0c9a1fd49440adc1bf7f19c1cce122091374d8ca261f19
$(PKG)_SITE:=https://github.com/quinot/choparp/archive/refs/tags/release
### WEBSITE:=https://github.com/quinot/choparp

$(PKG)_BINARY:=$($(PKG)_DIR)/choparp
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/choparp

$(PKG)_DEPENDS_ON += libpcap


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(CHOPARP_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		all

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(CHOPARP_DIR) clean

$(pkg)-uninstall:
	$(RM) $(CHOPARP_TARGET_BINARY)

$(PKG_FINISH)
