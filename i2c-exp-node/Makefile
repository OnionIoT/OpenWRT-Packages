
# Copyright (C) 2016 Onion Corporation
# 
# Author: Rajiv Puri  <rajiv@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
##OPENWRT PACKAGE MAKEFILE FOR node addons

include $(TOPDIR)/rules.mk
PKG_NAME:=i2c-exp-node-addons
PKG_VERSION:=0.2
PKG_RELEASE:=2


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/i2c-exp-node-addons.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk



# application packages
define Package/node-pwm-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Node module for Servo (PWM) Expansion
	DEPENDS:=+libonionpwmexp +libpthread +libstdcpp
endef


define Package/node-pwm-exp/description
Node module for Servo (PWM) Expansion
endef


define Package/node-relay-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Node module for Relay Expansion
	DEPENDS:=+libonionrelayexp +libpthread +libstdcpp
endef


define Package/node-relay-exp/description
Node module for Relay Expansion
endef


define Package/node-oled-exp
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Libraries
	TITLE:=Node module for OLED Expansion
	DEPENDS:=+libonionoledexp +libpthread +libstdcpp
endef


define Package/node-oled-exp/description
Node module for OLED Expansion
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

define Package/node-pwm-exp/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/pwm-exp/build/Release/node-pwm-exp.node $(1)/usr/bin/
endef

define Package/node-relay-exp/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/relay-exp/build/Release/node-relay-exp.node $(1)/usr/bin/
endef

define Package/node-oled-exp/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/oled-exp/build/Release/node-oled-exp.node $(1)/usr/bin/
endef


$(eval $(call BuildPackage,node-pwm-exp))
$(eval $(call BuildPackage,node-relay-exp))
$(eval $(call BuildPackage,node-oled-exp))

