# sonic ot-kvm one image installer

SONIC_ONE_IMAGE = sonic-ot-kvm.bin
$(SONIC_ONE_IMAGE)_MACHINE = ot-kvm
$(SONIC_ONE_IMAGE)_IMAGE_TYPE = onie
$(SONIC_ONE_IMAGE)_INSTALLS += $(SYSTEMD_SONIC_GENERATOR) \
                               $(PYTHON3_THRIFT_0_14_1) \
                               $(OTKVM_HALCLIENT_DEB)
$(SONIC_ONE_IMAGE)_LAZY_INSTALLS += $(OTKVM_OLSV_PLATFORM_MODULE)
ifeq ($(INSTALL_DEBUG_TOOLS),y)
$(SONIC_ONE_IMAGE)_DOCKERS += $(SONIC_INSTALL_DOCKER_DBG_IMAGES)
$(SONIC_ONE_IMAGE)_DOCKERS += $(filter-out $(patsubst %-$(DBG_IMAGE_MARK).gz,%.gz, $(SONIC_INSTALL_DOCKER_DBG_IMAGES)), $(SONIC_INSTALL_DOCKER_IMAGES))
else
$(SONIC_ONE_IMAGE)_DOCKERS = $(SONIC_INSTALL_DOCKER_IMAGES)
endif
SONIC_INSTALLERS += $(SONIC_ONE_IMAGE)