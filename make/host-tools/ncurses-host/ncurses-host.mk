$(call TOOLS_INIT, 6.5-20250419)
$(PKG)_SOURCE:=ncurses-$($(PKG)_VERSION).tgz
$(PKG)_HASH:=a1dcc10899d5bdb78b3cca0848e5f1d6aeed78992f495d84d449587fe36c7cf4
$(PKG)_SITE:=@GNU/ncurses,https://invisible-island.net/archives/ncurses/current,https://invisible-island.net/archives/ncurses
### WEBSITE:=https://invisible-island.net/ncurses/
### MANPAGE:=https://invisible-island.net/ncurses/announce.html
### CHANGES:=https://invisible-island.net/ncurses/NEWS.html
### SUPPORT:=fda77


$(TOOLS_SOURCE_DOWNLOAD)
$(TOOLS_UNPACKED)
$(TOOLS_CONFIGURED_CONFIGURE)

$($(PKG)_DIR)/progs/tic: $($(PKG)_DIR)/.configured
	$(TOOLS_SUBMAKE) -C $(NCURSES_HOST_DIR) all
	touch -c $@

$(TOOLS_DIR)/tic: $($(PKG)_DIR)/progs/tic
	$(INSTALL_FILE)

$(pkg)-precompiled: $(TOOLS_DIR)/tic


$(pkg)-clean:
	-$(MAKE) -C $(NCURSES_HOST_DIR) clean

$(pkg)-dirclean:
	$(RM) -r $(NCURSES_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) $(TOOLS_DIR)/tic

$(TOOLS_FINISH)
