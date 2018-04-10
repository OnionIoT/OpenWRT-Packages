#
# Copyright (C) 2010-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libfreefare
PKG_VERSION:=0.4.0
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/nfc-tools/libfreefare
PKG_SOURCE_PROTO:=git
#PKG_SOURCE_VERSION:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=c18f7028406e3de2938cbab070539f6d6c031baf

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/libfreefare/Default
  TITLE:=Library for high level manipulation of MIFARE cards
  URL:=http://nfc-tools.org/index.php/Libfreefare
endef

define Package/libfreefare
$(call Package/libfreefare/Default)
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libnfc +libopenssl
endef

define Package/libfreefare/description
  The libfreefare project aims to provide a convenient API for MIFARE card
  manipulations.
endef

define Package/libfreefare-examples
$(call Package/libfreefare/Default)
  TITLE+= (examples)
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libfreefare
endef

define Package/libfreefare-examples/description
  libfreefare is provided with some examples:
   * mifare-classic-format, mifare-desfire-format: attempt to format Mifare
   cards;
   * mifare-classic-write-ndef, mifare-desfire-write-ndef: write NDEF file to
   Mifare cards;
   * some mifare-desfire-* examples to made various access to Mifare DESFire.
endef

TARGET_CFLAGS += $(FPIC)

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/freefare.h $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libfreefare.{a,so*} $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/libfreefare.pc $(1)/usr/lib/pkgconfig/
endef

define Package/libfreefare/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libfreefare.so.* $(1)/usr/lib/
endef

define Package/libfreefare-examples/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/
endef

$(eval $(call BuildPackage,libfreefare))
$(eval $(call BuildPackage,libfreefare-examples))
