
# Copyright (C) 2016 Onion Corporation
# 
# Author: Rajiv Puri  <rajiv@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
include $(TOPDIR)/rules.mk
PKG_NAME:=onion-console-apps
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/Onion-Console.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/onion-console-editor
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Onion-Editor
	DEPENDS:=+rpcd +onion-console-base
endef

define Package/onion-console-terminal
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Onion-Terminal
	DEPENDS:=+rpcd +onion-console-base +shellinabox
endef

define Package/onion-console-webcam
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Onion-Webcam
	DEPENDS:=+rpcd +onion-console-base +mjpg-streamer
endef

define Package/onion-console-editor/description
Editor App for the Console
endef

define Package/onion-console-terminal/description
Terminal App for the console
endef

define Package/onion-console-webcam/description
Webcam App for the console
endef

define Package/onion-console-editor/install
	# copy the web site files, starting with the lib and element folders
	$(INSTALL_DIR) $(1)/www/apps/onion-editor
	$(INSTALL_DIR) $(1)/www/lib/juicy-ace-editor
	# copy the editor app
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-editor/* $(1)/www/apps/onion-editor/.
	cp -r $(PKG_BUILD_DIR)/www/lib/juicy-ace-editor/* $(1)/www/lib/juicy-ace-editor/.
	# cp -r $(PKG_BUILD_DIR)/www/* $(1)/www/.
endef

define Package/onion-console-terminal/install
	# copy the web site files, starting with the lib and element folders
	$(INSTALL_DIR) $(1)/www/apps/onion-terminal
	# copy the editor app
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-terminal/* $(1)/www/apps/onion-terminal/.
	# cp -r $(PKG_BUILD_DIR)/www/* $(1)/www/.
endef

define Package/onion-console-webcam/install
	# copy the web site files, starting with the lib and element folders
	$(INSTALL_DIR) $(1)/www/apps/onion-webcam
	# copy the editor app
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-webcam/* $(1)/www/apps/onion-webcam/.
	# cp -r $(PKG_BUILD_DIR)/www/* $(1)/www/.
endef


$(eval $(call BuildPackage,onion-console-terminal))
$(eval $(call BuildPackage,onion-console-editor))
$(eval $(call BuildPackage,onion-console-webcam))
