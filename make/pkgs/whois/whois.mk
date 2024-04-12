$(call PKG_INIT_BIN, 5.5.22)
$(PKG)_SOURCE:=$(pkg)_$($(PKG)_VERSION).tar.xz
$(PKG)_HASH:=03f12c27ae85870d7bcd95b14f3fb8b174532b2f2a59d8380c42ae436d0630d7
$(PKG)_SITE:=http://ftp.debian.org/debian/pool/main/w/whois
### WEBSITE:=https://www.linux.it/~md/software/
### MANPAGE:=https://manpages.debian.org/whois/whois.1.en.html
### CHANGES:=https://github.com/rfc1036/whois/tags
### CVSREPO:=https://github.com/rfc1036/whois

$(PKG)_BINARY:=$($(PKG)_DIR)/whois
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/whois

$(PKG)_DEPENDS_ON += libidn


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)


$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(WHOIS_DIR) all \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		CPPFLAGS="$(TARGET_CPPFLAGS)" \
		PERL="$(PERL)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(WHOIS_DIR) clean

$(pkg)-uninstall:
	$(RM) $(WHOIS_TARGET_BINARY)

$(PKG_FINISH)