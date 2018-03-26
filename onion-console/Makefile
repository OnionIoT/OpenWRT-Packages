
# Copyright (C) 2016 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=onion-console
PKG_VERSION:=0.1.4
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=HEAD # dev for dev branch, HEAD for master
PKG_SOURCE_URL:=https://github.com/OnionIoT/Onion-Console.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

# base console package
define Package/onion-console-base
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Web-based virtual desktop for the Omega, base contains settings and status app
	DEPENDS:=+rpcd 
endef


define Package/onion-console-base/description
Web-based virtual desktop for the Omega. Base package, only includes a few Apps. 
endef

define Package/onion-console-base/install
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
	$(INSTALL_DIR) $(1)/www/console
	# Create a lib directory
	$(INSTALL_DIR) $(1)/www/console/lib
	# Create a elements directory
	$(INSTALL_DIR) $(1)/www/console/elements
	# Create the apps directory
	$(INSTALL_DIR) $(1)/www/console/apps
	# Create the directory for the onion-launcher
	$(INSTALL_DIR) $(1)/www/console/apps/onion-launcher
	# Create the directort for onion-login
	$(INSTALL_DIR) $(1)/www/console/apps/onion-login
	# Create the directory for the onion-settings
	$(INSTALL_DIR) $(1)/www/console/apps/onion-settings


	#### Add the app shells 
	$(INSTALL_DIR) $(1)/www/console/apps/onion-editor
	$(INSTALL_DIR) $(1)/www/console/apps/onion-terminal
	$(INSTALL_DIR) $(1)/www/console/apps/onion-webcam

	### Installing the OLED, RELAY AND PWM

	$(INSTALL_DIR) $(1)/www/console/apps/onion-oled
	$(INSTALL_DIR) $(1)/www/console/apps/onion-pwm
	$(INSTALL_DIR) $(1)/www/console/apps/onion-relay
	$(INSTALL_DIR) $(1)/www/console/apps/onion-gpio



	# Create the services directory
	$(INSTALL_DIR) $(1)/www/console/services
	# Create the fonts directory
	$(INSTALL_DIR) $(1)/www/console/fonts
	# Create the images directory
	$(INSTALL_DIR) $(1)/www/console/images
	# copy the lib directory
	cp -r $(PKG_BUILD_DIR)/www/lib/* $(1)/www/console/lib/.
	# copy the elements directory
	cp -r $(PKG_BUILD_DIR)/www/elements/* $(1)/www/console/elements/.
	# copy the fonts directory
	cp -r $(PKG_BUILD_DIR)/www/fonts/* $(1)/www/console/fonts/.
	# copy the images directory
	cp -r $(PKG_BUILD_DIR)/www/images/* $(1)/www/console/images/.
	# copy the services directory
	cp -r $(PKG_BUILD_DIR)/www/services/* $(1)/www/console/services/.
	# copy other random files 
	cp $(PKG_BUILD_DIR)/www/.bowerrc $(1)/www/console/.bowerrc
	cp $(PKG_BUILD_DIR)/www/bower.json $(1)/www/console/bower.json
	cp $(PKG_BUILD_DIR)/www/index.html $(1)/www/console/index.html
	# copy the apps into the directory
	# copy the launcher app
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-launcher/* $(1)/www/console/apps/onion-launcher/.
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-settings/* $(1)/www/console/apps/onion-settings/.
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-login/* $(1)/www/console/apps/onion-login/.

	cp -r $(PKG_BUILD_DIR)/www/apps/onion-oled/* $(1)/www/console/apps/onion-oled/.
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-gpio/* $(1)/www/console/apps/onion-gpio/.
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-pwm/* $(1)/www/console/apps/onion-pwm/.
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-relay/* $(1)/www/console/apps/onion-relay/.

	## Adding the index page

	cp -r $(PKG_BUILD_DIR)/www/apps/onion-editor/* $(1)/www/console/apps/onion-editor/.
	rm -r $(1)/www/console/apps/onion-editor/onion-editor.html

	cp -r $(PKG_BUILD_DIR)/www/apps/onion-terminal/* $(1)/www/console/apps/onion-terminal/.
	rm -r $(1)/www/console/apps/onion-terminal/onion-terminal.html	

	cp -r $(PKG_BUILD_DIR)/www/apps/onion-webcam/* $(1)/www/console/apps/onion-webcam/.
	rm -r $(1)/www/console/apps/onion-webcam/onion-webcam.html

	rm -r $(1)/www/console/lib/juicy-ace-editor/
	# cp -r $(PKG_BUILD_DIR)/www/* $(1)/www/console/.

	# Add the 
endef

# editor
define Package/onion-console-editor
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Onion-Editor
	DEPENDS:=+rpcd +onion-console-base +cgi-io
endef

define Package/onion-console-editor/description
Editor App for the Console
endef

define Package/onion-console-editor/install
	# copy the web site files, starting with the lib and element folders
	$(INSTALL_DIR) $(1)/www/console/apps/onion-editor
	$(INSTALL_DIR) $(1)/www/console/lib/juicy-ace-editor
	# copy the editor app
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-editor/onion-editor.html $(1)/www/console/apps/onion-editor/onion-editor.html
	cp -r $(PKG_BUILD_DIR)/www/lib/juicy-ace-editor/* $(1)/www/console/lib/juicy-ace-editor/.
	# cp -r $(PKG_BUILD_DIR)/www/* $(1)/www/console/.
endef

# terminal
define Package/onion-console-terminal
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Onion-Terminal
	DEPENDS:=+rpcd +onion-console-base +shellinabox
endef

define Package/onion-console-terminal/description
Terminal App for the console
endef

define Package/onion-console-terminal/install
	# copy the web site files, starting with the lib and element folders
	$(INSTALL_DIR) $(1)/www/console/apps/onion-terminal
	# copy the editor app
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-terminal/onion-terminal.html $(1)/www/console/apps/onion-terminal/onion-terminal.html
endef

# webcam
define Package/onion-console-webcam
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Onion-Webcam
	DEPENDS:=+rpcd +onion-console-base +mjpg-streamer
endef

define Package/onion-console-webcam/description
Webcam App for the console
endef

define Package/onion-console-webcam/install
	# copy the web site files, starting with the lib and element folders
	$(INSTALL_DIR) $(1)/www/console/apps/onion-webcam
	# copy the webcam app
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-webcam/onion-webcam.html $(1)/www/console/apps/onion-webcam/onion-webcam.html
endef

# nodered
define Package/onion-console-node-red
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Console
	TITLE:=Onion-Node-Red
	DEPENDS:=+onion-console-base +nodejs
endef

define Package/onion-console-node-red/description
Node red app fo the console
endef

define Package/onion-console-node-red/install
	# copy the node-red element file
	$(INSTALL_DIR) $(1)/www/console/apps/onion-node-red
	cp -r $(PKG_BUILD_DIR)/www/apps/onion-node-red/onion-node-red.html $(1)/www/console/apps/onion-node-red/onion-node-red.html
endef


# calls to build each package
$(eval $(call BuildPackage,onion-console-base))
$(eval $(call BuildPackage,onion-console-terminal))
$(eval $(call BuildPackage,onion-console-editor))
$(eval $(call BuildPackage,onion-console-webcam))
$(eval $(call BuildPackage,onion-console-node-red))
