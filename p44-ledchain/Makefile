include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=p44-ledchain

PKG_MIRROR_HASH:=dc5c915d8d9c236486ecbebe242a9ac2558072f53bda4184cd978640d48d9b60
PKG_SOURCE_URL:=https://github.com/plan44/plan44-feed.git
PKG_SOURCE_DATE:=2023-08-16
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=9d4ed3ebe1a2d06cad67524a7bbb2ad7596f133e

include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
	SUBMENU:=Other modules
	DEPENDS:=@(TARGET_ramips_mt76x8||TARGET_ramips_mt7688)
	TITLE:=p44-ledchain driver for WS28xx/SK68xx
	FILES:= $(PKG_BUILD_DIR)/p44-ledchain/src/p44-ledchain.ko
endef

define KernelPackage/$(PKG_NAME)/description
	This package contains the p44-ledchain kernel driver for WS28xx and SK68xx type serial LED chains
	for MT7688, which uses PWM unit to generate the WS28xx timing without blocking IRQs.
endef

MAKE_OPTS:= \
	    ARCH="$(LINUX_KARCH)" \
	    CROSS_COMPILE="$(TARGET_CROSS)" \
	    SUBDIRS="$(PKG_BUILD_DIR)"

define Build/Compile
	$(KERNEL_MAKE) EXTRA_CFLAGS=-Wno-vla M="$(PKG_BUILD_DIR)/p44-ledchain/src"
endef

$(eval $(call KernelPackage,$(PKG_NAME)))