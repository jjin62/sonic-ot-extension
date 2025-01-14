# syncd of molex

OPLINKSYNCD_VERSION = 1.0.0

OPLINKSYNCD = oplinksyncd_$(OPLINKSYNCD_VERSION)_$(CONFIGURED_ARCH).deb
$(OPLINKSYNCD)_SRC_PATH = $(PLATFORM_PATH)/sonic-fairedis
$(OPLINKSYNCD)_DEPENDS += $(LIBSWSSCOMMON_DEV) $(OPLINKHAL_DEV) $(OPLINKUTIL)
$(OPLINKSYNCD)_RDEPENDS += $(LIBSWSSCOMMON) $(OPLINKHAL) $(OPLINKUTIL)
SONIC_MAKE_DEBS += $(OPLINKSYNCD)

export OPLINKSYNCD
