#
# Copyright (C) 2018 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=oos-app-camera
PKG_VERSION:=1.0.0
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD # dev for dev branch, HEAD for master
PKG_SOURCE_URL:=https://github.com/OnionIoT/OOS-App-Camera.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/oos-app-camera
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=OS
	TITLE:=OnionOS App for managing camera stream and timelapse
	DEPENDS:=+mjpg-streamer +onion-script
endef


define Package/oos-app-camera/description
OnionOS App for managing camera stream and timelapse
endef

define Package/oos-app-camera/install
	# install the scripts
	$(INSTALL_DIR) $(1)/www/apps/oos-app-camera $(1)/etc/init.d $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/timelapse $(1)/etc/init.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/run.sh $(1)/www/apps/oos-app-camera/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/save-token.sh $(1)/www/apps/oos-app-camera/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/omega/snap-to-dropbox.sh $(1)/www/apps/oos-app-camera/
	# copy the web site files
	$(CP) -r $(PKG_BUILD_DIR)/omega/www/* $(1)/www/apps/oos-app-camera/
endef


# calls to build each package
$(eval $(call BuildPackage,oos-app-camera))
