
# Copyright (C) 2016 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-gpio-sysfs
PKG_VERSION:=0.2
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/onion-gpio-sysfs.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk


# python module packages
define Package/pyOnionGpio
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python module with object that implements programming the GPIOs via the sysfs interface
	DEPENDS:=+python-base
endef

define Package/pyOnionGpio/description 
Python module with object that implements programming the GPIOs via the sysfs interface
endef


PYTHON_VERSION = "2.7"
TARGET_CXXFLAGS += $(FPIC)

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)
endef

define Package/pyOnionGpio/install
	# install python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON_VERSION)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/python/onionGpio.py $(1)/usr/lib/python$(PYTHON_VERSION)
endef


$(eval $(call BuildPackage,pyOnionGpio))

