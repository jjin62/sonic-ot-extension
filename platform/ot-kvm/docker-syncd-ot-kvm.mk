# docker image for ot-kvm syncd

DOCKER_SYNCD_PLATFORM_CODE = ot-kvm
include $(PLATFORM_PATH)/../template/docker-syncd-bullseye.mk

$(DOCKER_SYNCD_BASE)_DEPENDS += $(SYNCD) \
                                $(OTKVM_LIBOTAI_DEB) \
                                $(OTKVM_HALSERVER_DEB)

$(DOCKER_SYNCD_BASE)_DBG_DEPENDS += $(SYNCD_DBG) \
                                $(LIBSWSSCOMMON_DBG) \
                                $(LIBSAIMETADATA_DBG) \
                                $(LIBSAIREDIS_DBG)

$(DOCKER_SYNCD_BASE)_VERSION = 1.0.0
$(DOCKER_SYNCD_BASE)_PACKAGE_NAME = syncd

$(DOCKER_SYNCD_BASE)_RUN_OPT += -v /host/warmboot:/var/warmboot

SONIC_BULLSEYE_DOCKERS += $(DOCKER_SYNCD_BASE)