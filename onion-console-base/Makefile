
# Copyright (C) 2016 Onion Corporation
# 
# Author: Rajiv Puri  <rajiv@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-console-base
PKG_VERSION:=0.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE_URL:=https://github.com/OnionIoT/Onion-Console.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Web-based virtual desktop for the Omega, base contains settings and status app
	DEPENDS:=+rpcd 
endef


define Package/$(PKG_NAME)/description
Base Version,Web-based virtual desktop for the Omega. Only Includes a few Apps. 
endef

define Package/$(PKG_NAME)/install
	# install the acl permissions file
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/acl.d/onion-console.json $(1)/usr/share/rpcd/acl.d/onion-console.json
	# install scripts
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/factory-reset.sh $(1)/usr/sbin/factory-reset
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/power-down.sh $(1)/usr/sbin/power-down
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/change-password.sh $(1)/usr/sbin/change-password
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/disk-space.sh $(1)/usr/sbin/disk-space
	# install the rpcd script
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rpcd/onion-console.sh $(1)/usr/libexec/rpcd/onion-console
	# copy the web site files, starting with the lib and element folders
	$(INSTALL_DIR) $(1)/www
	# Create a lib directory
	$(INSTALL_DIR) $(1)/www/lib
	# Create a elements directory
	$(INSTALL_DIR) $(1)/www/elements
	# Create the apps directory
	$(INSTALL_DIR) $(1)/www/apps
	# Create the directory for the onion-launcher
	$(INSTALL_DIR) $(1)/www/apps/onion-launcher
	# Create the directort for onion-login
	$(INSTALL_DIR) $(1)/www/apps/onion-login
	# Create the directory for the onion-settings
	$(INSTALL_DIR) $(1)/www/apps/onion-settings
	# Create the services directory
	$(INSTALL_DIR) $(1)/www/services
	# Create the fonts directory
	$(INSTALL_DIR) $(1)/www/fonts
	# Create the images directory
	$(INSTALL_DIR) $(1)/www/images
	# copy the lib directory
	cp -r $(PKG_BUILD_DIR)/www/lib/* $(1)/www/lib/.
	# copy the elements directory
	cp -r $(PKG_BUILD_DIR)/www/elements/* $(1)/www/elements/.
	# copy the fonts directory
	cp -r $(PKG_BUILD_DIR)/www/fonts/* $(1)/www/fonts/.
	# copy the images directory
	cp -r $(PKG_BUILD_DIR)/www/images/* $(1)/www/images/.
	# copy the services directory
	cp -r $(PKG_BUILD_DIR)/www/services/* $(1)/www/services/.
	# copy other random files 
	cp $(PKG_BUILD_DIR)/www/.bowerrc $(1)/www/.bowerrc
	cp $(PKG_BUILD_DIR)/www/bower.json $(1)/www/bower.json
	cp $(PKG_BUILD_DIR)/www/index.html $(1)/www/index.html
	# copy the apps into the directory
	# copy the launcher app
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-launcher/* $(1)/www/apps/onion-launcher/.
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-settings/* $(1)/www/apps/onion-settings/.
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-login/* $(1)/www/apps/onion-login/.
	# cp -r $(PKG_BUILD_DIR)/www/* $(1)/www/.
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
