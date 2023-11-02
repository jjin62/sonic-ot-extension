# sonic kvm image

SONIC_KVM_IMAGE = sonic-vs.img.gz
$(SONIC_KVM_IMAGE)_INSTALLS += $(SYSTEMD_SONIC_GENERATOR)
$(SONIC_KVM_IMAGE)_LAZY_INSTALLS += $(OTKVM_OLSV_PLATFORM_MODULE)
$(SONIC_KVM_IMAGE)_MACHINE = vs
$(SONIC_KVM_IMAGE)_IMAGE_TYPE = kvm
ifeq ($(INSTALL_DEBUG_TOOLS),y)
$(SONIC_KVM_IMAGE)_DOCKERS += $(SONIC_INSTALL_DOCKER_DBG_IMAGES)
$(SONIC_KVM_IMAGE)_DOCKERS += $(filter-out $(patsubst %-$(DBG_IMAGE_MARK).gz,%.gz, $(SONIC_INSTALL_DOCKER_DBG_IMAGES)), $(SONIC_INSTALL_DOCKER_IMAGES))
else
$(SONIC_KVM_IMAGE)_DOCKERS = $(SONIC_INSTALL_DOCKER_IMAGES)
endif
$(SONIC_KVM_IMAGE)_FILES = $(ONIE_RECOVERY_IMAGE) $(ONIE_RECOVERY_KVM_4ASIC_IMAGE) $(ONIE_RECOVERY_KVM_6ASIC_IMAGE)
SONIC_INSTALLERS += $(SONIC_KVM_IMAGE)
