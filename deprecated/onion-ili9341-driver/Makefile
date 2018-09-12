
# Copyright (C) 2016 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-ili9341-driver
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=git@github.com:OnionIoT/onion-ili9341-driver.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# library packages
define Package/libonionili9341
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library for TFT ILI9341 Driver
	DEPENDS:=+liboniondebug +libonionspi +libugpio
endef

define Package/libonionst7725/description
Library for TFT ILI9341 Driver
endef

# application package
define Package/ili9341-test
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Tool to test TFT ILI9341 Driver
	DEPENDS:=+liboniondebug +libonionili9341
endef

define Package/ili9341-test/description
Tool to test TFT ILI9341 Driver
endef

# python module package
define Package/pyOnionIli9341
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python module to implement driver for TFT ILI9341 
	DEPENDS:=+python-base +liboniondebug +libonionspi +libonionili9341
endef

define Package/pyOnionIli9341/description
Python module to implement driver for TFT ILI9341
endef

PYTHON_VERSION = "2.7"
TARGET_LIB += -loniondebug -lonionspi -lonionili9341 -lugpio
TARGET_CFLAGS += $(FPIC)
TARGET_PYINC += "-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION)"

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIB)" \
	PYINC="$(TARGET_PYINC)"

#	PYVER="$(PYTHON_VERSION)"
endef

define Build/InstallDev
	mkdir -p $(STAGING_DIR)/usr/include $(STAGING_DIR)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/include/onion-ili9341-driver.h $(STAGING_DIR)/usr/include/
	$(CP)   $(PKG_BUILD_DIR)/lib/libonionili9341.so $(STAGING_DIR)/usr/lib/
endef

define Package/libonionili9341/install
	# install the static library object 
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/lib/libonionili9341.so $(1)/usr/lib/
endef

define Package/ili9341-test/install
	$(INSTALL_DIR) $(1)/usr/bin
	# install the binary
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/ili9341-test $(1)/usr/bin/
endef

define Package/pyOnionIli9341/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION)
	$(CP)   $(PKG_BUILD_DIR)/lib/python/onionIli9341.so $(1)/usr/lib/python$(PYTHON_VERSION)
endef


$(eval $(call BuildPackage,libonionili9341))
$(eval $(call BuildPackage,ili9341-test))
#$(eval $(call BuildPackage,pyOnionIli9341))

