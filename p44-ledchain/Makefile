include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=p44-ledchain
# version of what we are downloading
PKG_VERSION:=9
# version of this makefile
PKG_RELEASE:=12

PKG_SOURCE_URL:=https://github.com/plan44/plan44-feed.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=d0450ddc62807beb88df3dfd7a9dddda35879e9c

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
		$(KERNEL_MAKE_FLAGS) \
	    SUBDIRS="$(PKG_BUILD_DIR)"

define Build/Compile
	$(KERNEL_MAKE) EXTRA_CFLAGS=-Wno-vla M="$(PKG_BUILD_DIR)/p44-ledchain/src"
endef

$(eval $(call KernelPackage,$(PKG_NAME)))