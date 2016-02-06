
# Copyright (C) 2016 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=device-client
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=git@github.com:OnionIoT/device-client.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk


# application package
define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Network
	TITLE:=Client for communication with Onion Cloud Device Server
	DEPENDS:=+libpthread +libcurl +liboniondebug +libjson-c +libubus +libblobmsg-json +libuci
endef

define Package/$(PKG_NAME)/description
Client for communication with Onion Cloud Device Server
endef


TARGET_LIB += -lpthread -lcurl -loniondebug -ljson-c -lubus -lubox -lblobmsg_json -luci
TARGET_CFLAGS += $(FPIC)

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIB)"
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	# install the binary
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/device-client $(1)/usr/sbin/
	# install the init.d script
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/init.d/device-client.sh $(1)/etc/init.d/device-client
endef



$(eval $(call BuildPackage,$(PKG_NAME)))

