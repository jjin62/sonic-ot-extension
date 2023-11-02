include $(PLATFORM_PATH)/oplinkutil.mk
include $(PLATFORM_PATH)/oplinkhal.mk
include $(PLATFORM_PATH)/sonic-fairedis.mk
include $(PLATFORM_PATH)/docker-olssyncd-molex.mk
include $(PLATFORM_PATH)/platform-modules-ot-kvm.mk
include $(PLATFORM_PATH)/sonic-version.mk
include $(PLATFORM_PATH)/one-image.mk
include $(PLATFORM_PATH)/onie.mk
include $(PLATFORM_PATH)/kvm-image.mk
include $(PLATFORM_PATH)/raw-image.mk

SONIC_ALL += $(SONIC_ONE_IMAGE) $(SONIC_KVM_IMAGE) $(SONIC_RAW_IMAGE)
