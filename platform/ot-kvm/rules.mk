include $(PLATFORM_PATH)/hal-server.mk
include $(PLATFORM_PATH)/hal-client.mk
include $(PLATFORM_PATH)/otai.mk
include $(PLATFORM_PATH)/docker-syncd-ot-kvm.mk
include $(PLATFORM_PATH)/platform-modules-ot-kvm.mk
include $(PLATFORM_PATH)/sonic-version.mk
include $(PLATFORM_PATH)/one-image.mk
include $(PLATFORM_PATH)/onie.mk
include $(PLATFORM_PATH)/kvm-image.mk
include $(PLATFORM_PATH)/raw-image.mk

SONIC_ALL += $(SONIC_ONE_IMAGE) $(SONIC_KVM_IMAGE) $(SONIC_RAW_IMAGE)

# Inject ot-kvm otai into syncd
$(SYNCD)_DEPENDS += $(OTKVM_LIBOTAI_DEB) $(LIBSAIMETADATA_DEV)

# Inject ot-kvm hal dependency library into pmon
$(DOCKER_PLATFORM_MONITOR)_DEPENDS += $(PYTHON3_THRIFT_0_14_1) $(OTKVM_HALCLIENT_DEB)
