
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=pwm-exp
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/pwm-expansion-driver.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

define Package/pwm-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for Servo (PWM) Expansion
	#DEPENDS:= $(CXX_DEPENDS)
endef


define Package/pwm-exp/description
Driver for Servo (PWM) Expansion
endef


define Package/relay-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for Relay Expansion
	#DEPENDS:= $(CXX_DEPENDS)
endef


define Package/relay-exp/description
Driver for Relay Expansion
endef


define Package/pwm-exp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/pwm-exp $(1)/usr/sbin/
endef

define Package/relay-exp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/relay-exp $(1)/usr/sbin/
endef


$(eval $(call BuildPackage,pwm-exp))
$(eval $(call BuildPackage,relay-exp))

