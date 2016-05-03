
# Copyright (C) 2015 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
##OPENWRT PACKAGE MAKEFILE FOR node addons

include $(TOPDIR)/rules.mk
PKG_NAME:=i2c-node-addons
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=git@github.com:OnionIoT/i2c-exp-node-addons.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk



# application packages
define Package/pwm-exp-node
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for Servo (PWM) Expansion
	DEPENDS:=+libonionpwmexp +libpthread +libstdcpp
endef


define Package/pwm-exp-node/description
Node Driver for Servo (PWM) Expansion
endef


define Package/relay-exp-node
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for Relay Expansion
	DEPENDS:=+libonionrelayexp +libpthread +libstdcpp
endef


define Package/relay-exp-node/description
Node Driver for Relay Expansion
endef


define Package/oled-exp-node
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Drivers
	TITLE:=Driver for OLED Expansion
	DEPENDS:=+libonionoledexp +libpthread +libstdcpp
endef


define Package/oled-exp-node/description
Node Driver for OLED Expansion
endef



TARGET_CFLAGS += $(FPIC)


define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)"\
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" 
endef

##Whats this do?
define Build/InstallDev

endef

define Package/pwm-exp-node/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/Pwm_Expansion/build/Release/pwm-exp-addon.node $(1)/usr/bin/
endef

define Package/relay-exp-node/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/Relay_Expansion/build/Release/relay-exp-addon.node $(1)/usr/bin/
endef

define Package/oled-exp-node/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/Oled_Expansion/build/Release/oled-exp-addon.node $(1)/usr/bin/
endef


$(eval $(call BuildPackage,pwm-exp-node))
$(eval $(call BuildPackage,relay-exp-node))
$(eval $(call BuildPackage,oled-exp-node))

