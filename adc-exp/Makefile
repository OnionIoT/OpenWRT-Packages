
# Copyright (C) 2018 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=adc-exp
PKG_VERSION:=0.3
PKG_RELEASE:=3


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/adc-exp.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/adc-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Command line utility for ADC Expansion
	DEPENDS:=+bc +coreutils-sleep
endef

define Package/adc-exp/description
Command line utility for ADC Expansion
endef

define Package/python-adc-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python module to interact with Onion ADC Expansion
	DEPENDS:=+python-base +pyOmegaExpansion
endef

define Package/python-adc-exp/description
Python module to interact with Onion ADC Expansion
endef

define Package/python3-adc-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Python3 module to interact with Onion ADC Expansion
	DEPENDS:=+python3-base +python3-omega-expansion +python3-onion-i2c
endef

define Package/python3-adc-exp/description
Python3 module to interact with Onion ADC Expansion
endef

#define Package/$(PKG_NAME)/Build/Compile
#	$(MAKE) -C $(PKG_BUILD_DIR)
#endef

PYTHON2:=2.7
PYTHON3:=3.6

define Package/adc-exp/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/adc-exp.sh $(1)/usr/bin/adc-exp
endef

define Package/python-adc-exp/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python2.7/OmegaExpansion
	$(CP) $(PKG_BUILD_DIR)/python/AdcExp.py $(1)/usr/lib/python2.7/OmegaExpansion
endef

define Package/python3-adc-exp/install
	# install the python module
	$(INSTALL_DIR) $(1)/usr/lib/python$(PYTHON3)/OmegaExpansion
	$(CP) $(PKG_BUILD_DIR)/python/AdcExp.py $(1)/usr/lib/python$(PYTHON3)/OmegaExpansion
endef


$(eval $(call BuildPackage,adc-exp))
$(eval $(call BuildPackage,python-adc-exp))
$(eval $(call BuildPackage,python3-adc-exp))
