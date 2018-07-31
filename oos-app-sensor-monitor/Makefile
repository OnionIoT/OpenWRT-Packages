#
# Copyright (C) 2018 Onion Corporation
#
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=oos-app-sensor-monitor
PKG_VERSION:=1.0.0
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD # dev for dev branch, HEAD for master
PKG_SOURCE_URL:=https://github.com/OnionIoT/OOS-App-Sensor-Monitor.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/oos-app-sensor-monitor
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=OS
	TITLE:=OnionOS App for sensor measurement dashboard
	DEPENDS:=+mjpg-streamer +onion-script +curl +ca-bundle
endef


define Package/oos-app-sensor-monitor/description
OnionOS App for managing camera stream and timelapse
endef

define Package/oos-app-sensor-monitor/install
	# install the scripts
	$(INSTALL_DIR) $(1)/www/apps/sensor-monitor-app
	# copy the web site files
	$(CP) -r $(PKG_BUILD_DIR)/omega/www/* $(1)/www/apps/sensor-monitor-app/
endef


# calls to build each package
$(eval $(call BuildPackage,oos-app-sensor-monitor))
