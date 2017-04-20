
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=neopixel-tool
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/neopixel-tool.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk


# library package
define Package/libonionneopixel
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Library that provides functions to interact with Neopixels via the Arduino Dock
	DEPENDS:=+liboniondebug +libonioni2c $(CXX_DEPENDS)
endef

define Package/libonionneopixel/description 
Library that provides functions to interact with Neopixels via the Arduino Dock
endef

# application package
define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Tool to enable use of Neopixels with the Arduino Dock
	DEPENDS:=+libonionneopixel
endef


define Package/$(PKG_NAME)/description
Tool to enable use of Neopixels with the Arduino Dock
endef

# python module packages
define Package/pyOmegaArduinoDock
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Setup for OmegaArduinoDock Python Package
	DEPENDS:=+python-base
endef

define Package/pyOmegaArduinoDock/description
Setup for OmegaArduinoDock Python Package
endef

define Package/pyNeopixel
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python module to control Neopixels via the Arduino Dock
	DEPENDS:=+libonionneopixel +python-base +python-ctypes +pyOmegaArduinoDock
endef

define Package/pyNeopixel/description
Python module to control Neopixels via the Arduino Dock
endef

PYTHON_VERSION = "2.7"
TARGET_CXXFLAGS += $(FPIC)

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CXX="$(TARGET_CXX)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)"
endef

define Build/InstallDev
	mkdir -p $(1)/usr/include $(1)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/include/neopixel.h $(1)/usr/include/
	$(CP)   $(PKG_BUILD_DIR)/include/neopixel_Cwrapper.h $(1)/usr/include/
	$(CP)   $(PKG_BUILD_DIR)/lib/libonionneopixel.so $(1)/usr/lib/
endef


define Package/libonionneopixel/install
	# install the static library object
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP)   $(PKG_BUILD_DIR)/lib/libonionneopixel.so $(1)/usr/lib/	
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/$(PKG_NAME) $(1)/usr/bin/
endef


define Package/pyOmegaArduinoDock/install
	# setup the OmegaArduinoDock package
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION)/OmegaArduinoDock
	touch $(1)/usr/lib/python$(PYTHON_VERSION)/OmegaArduinoDock/__init__.py 
endef	

define Package/pyNeopixel/install
	# install python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION)/OmegaArduinoDock
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/python/neopixel.py $(1)/usr/lib/python$(PYTHON_VERSION)/OmegaArduinoDock
endef


$(eval $(call BuildPackage,libonionneopixel))
$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,pyOmegaArduinoDock))
$(eval $(call BuildPackage,pyNeopixel))

