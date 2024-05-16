
# Copyright (C) 2023 Onion Corporation
# 
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=onion-dt-overlay
PKG_VERSION:=1.0
PKG_RELEASE:=4
KERNEL_BUILD_DIR ?= $(BUILD_DIR)/linux-$(BOARD)$(if $(SUBTARGET),_$(SUBTARGET))
LINUX_DIR ?= $(KERNEL_BUILD_DIR)/linux-$(LINUX_VERSION)
DTC=$(LINUX_DIR)/scripts/dtc/dtc

include $(INCLUDE_DIR)/package.mk

define Package/onion-dt-overlay/default
	TITLE:=onion-dt-overlay
	SECTION:=onion
	CATEGORY:=Onion
	SUBMENU:=Utilities
	TITLE:=Onion DT Overlay
endef

define Package/onion-dt-overlay
	$(Package/onion-dt-overlay/default)
endef

define Package/onion-dt-overlay/description
	Onion DT Overlay
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) src $(PKG_BUILD_DIR)
endef

define Build/Compile
	true
endef

define Package/onion-dt-overlay/install
	true
endef

define BuildDtbo

  define Package/onion-dt-overlay-$(1)
	$(Package/onion-dt-overlay/default)
	TITLE+= ($(1) DTBO)
	DEPENDS+=onion-dt-overlay $(2)
  endef

  define Package/onion-dt-overlay-$(1)/description
	$(3)
  endef

  define Package/onion-dt-overlay-$(1)/install
	$(INSTALL_DIR) $$(1)/lib/firmware/device-tree/overlays/
	$(DTC) -b 0 -@ -O dtb $(PKG_BUILD_DIR)/src/$(1).dts -o $(PKG_BUILD_DIR)/src/$(1).dtbo
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/src/$(1).dtbo $$(1)/lib/firmware/device-tree/overlays/$(1).dtbo
  endef

  define Package/onion-dt-overlay-$(1)/postinst
	#!/bin/sh

	if [ -z "$$$${IPKG_INSTROOT}" ]; then
		if ! cat /proc/mounts | grep -q config; then
			echo "Mounting configfs..."
			mount -t configfs none /sys/kernel/config
		fi

		mkdir -p /sys/kernel/config/device-tree/overlays/$(1)
		cat /lib/firmware/device-tree/overlays/$(1).dtbo > /sys/kernel/config/device-tree/overlays/$(1)/dtbo
	fi
  endef

  $$(eval $$(call BuildPackage,onion-dt-overlay-$(1)))

endef

$(eval $(call BuildPackage,onion-dt-overlay))
$(eval $(call BuildDtbo,sw-spi,,Provides SW SPI))
$(eval $(call BuildDtbo,w1-gpio,+kmod-w1 +kmod-w1-master-gpio +kmod-w1-slave-therm,Provides One Wire GPIO))
