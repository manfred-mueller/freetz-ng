$(call PKG_INIT_LIB, 1.0)

$(PKG)_BINARY:=$($(PKG)_DIR)/$(pkg).so.$($(PKG)_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_LIB)/$(pkg).so.$($(PKG)_VERSION)

$(PKG)_REBUILD_SUBOPTS += FREETZ_TARGET_UCLIBC_MAJOR_VERSION
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libctlmgr_WITH_DEBUG
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libctlmgr_WITH_CHMOD
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libctlmgr_WITH_RENAME
$(PKG)_REBUILD_SUBOPTS += FREETZ_AVM_PROP_LIBC_GLIBC
$(PKG)_REBUILD_SUBOPTS += FREETZ_AVM_PROP_LIBC_MUSL
$(PKG)_REBUILD_SUBOPTS += FREETZ_AVM_PROP_LIBC_UCLIBC

$(PKG)_CPPFLAGS += $(if $(FREETZ_LIB_libctlmgr_WITH_DEBUG),-DDEBUG)
$(PKG)_CPPFLAGS += $(if $(FREETZ_LIB_libctlmgr_WITH_CHMOD),-DD_CHMOD)
$(PKG)_CPPFLAGS += $(if $(FREETZ_LIB_libctlmgr_WITH_RENAME),-DD_RENAME)
$(PKG)_CPPFLAGS += -DLIBC_LOCATION='\"/lib/$(call qstrip,$(FREETZ_AVM_HAS_LIBC_FILE))\"'


$(PKG_LOCALSOURCE_PACKAGE)
$(PKG_CONFIGURED_NOP)

$($(PKG)_DIR)/.compiled: $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(LIBCTLMGR_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		CPPFLAGS="$(strip $(LIBCTLMGR_CPPFLAGS))" \
		LIB_VERSION="$(LIBCTLMGR_VERSION)" \
		all
	[ "$(FREETZ_SEPARATE_AVM_UCLIBC)" != "y" ] || $(PATCHELF) --remove-rpath "$(LIBCTLMGR_BINARY)"
	[ "$(FREETZ_SEPARATE_AVM_UCLIBC)" != "y" ] || $(PATCHELF) --replace-needed "libc.so.0" "$(call qstrip,$(FREETZ_AVM_HAS_LIBC_FILE))" "$(LIBCTLMGR_BINARY)"
	@touch "$@"

$($(PKG)_BINARY): $($(PKG)_DIR)/.compiled

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(LIBCTLMGR_DIR) clean

$(pkg)-uninstall:
	$(RM) $(LIBCTLMGR_DEST_LIB)/libctlmgr*.so*

$(PKG_FINISH)
