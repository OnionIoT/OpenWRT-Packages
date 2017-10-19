
# Copyright (C) 2016 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=power-dock
PKG_VERSION:=0.4
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/power-dock.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk


# application package
define Package/power-dock
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Onion Power Dock Application
	DEPENDS:=+libugpio +liboniondebug
endef

define Package/power-dock/description
Onion Power Dock Application
endef

define Package/power-dock2
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Onion Power Dock 2 application 
	DEPENDS:=+power-dock +bc
endef

define Package/power-dock2/description
Onion Power Dock 2 application
endef

TARGET_CFLAGS += $(FPIC)
TARGET_LIB += -lugpio -loniondebug

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIB)"
endef


define Package/power-dock/install
	$(INSTALL_DIR) $(1)/usr/bin
	# install the binary
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/power-dock $(1)/usr/bin/
endef

define Package/power-dock2/install
	$(INSTALL_DIR) $(1)/usr/bin
	# install the script
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/power-dock2.sh $(1)/usr/bin/power-dock2
endef


$(eval $(call BuildPackage,power-dock))
$(eval $(call BuildPackage,power-dock2))

