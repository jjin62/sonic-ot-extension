# docker image for ot-kvm syncd

DOCKER_SYNCD_PLATFORM_CODE = ot-kvm
include $(PLATFORM_PATH)/../template/docker-syncd-bullseye.mk

$(DOCKER_SYNCD_BASE)_DEPENDS += $(SYNCD) \
                                $(OT_KVM_THRIFT_LIB_DEB) \
                                $(OT_KVM_THRIFT_LIB_DEV_DEB) \
                                $(OTKVM_LIBOTAI_DEB) \
                                $(OTKVM_HALSERVER_DEB)

$(DOCKER_SYNCD_BASE)_DBG_DEPENDS += $(SYNCD_DBG) \
                                $(LIBSWSSCOMMON_DBG) \
                                $(LIBSAIMETADATA_DBG) \
                                $(LIBSAIREDIS_DBG)

$(DOCKER_SYNCD_BASE)_VERSION = 1.0.0
$(DOCKER_SYNCD_BASE)_PACKAGE_NAME = syncd

$(DOCKER_SYNCD_BASE)_RUN_OPT += -v /host/warmboot:/var/warmboot
