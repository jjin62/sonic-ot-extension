# docker image for molex ols-syncd

DOCKER_OLSSYNCD_PLATFORM_CODE = molex

DOCKER_OLSSYNCD_BASE_STEM = docker-olssyncd-$(DOCKER_OLSSYNCD_PLATFORM_CODE)
DOCKER_OLSSYNCD_BASE = $(DOCKER_OLSSYNCD_BASE_STEM).gz

$(DOCKER_OLSSYNCD_BASE)_PATH = $(PLATFORM_PATH)/docker-olssyncd-$(DOCKER_OLSSYNCD_PLATFORM_CODE)

$(DOCKER_OLSSYNCD_BASE)_FILES += $(SUPERVISOR_PROC_EXIT_LISTENER_SCRIPT)

$(DOCKER_OLSSYNCD_BASE)_LOAD_DOCKERS += $(DOCKER_CONFIG_ENGINE_BUSTER)

SONIC_DOCKER_IMAGES += $(DOCKER_OLSSYNCD_BASE)
# ifneq ($(ENABLE_OLSSYNCD_RPC),y)
SONIC_INSTALL_DOCKER_IMAGES += $(DOCKER_OLSSYNCD_BASE)
# endif

$(DOCKER_OLSSYNCD_BASE)_CONTAINER_NAME = olssyncd
$(DOCKER_OLSSYNCD_BASE)_RUN_OPT += --privileged -t
$(DOCKER_OLSSYNCD_BASE)_RUN_OPT += -v /host/machine.conf:/etc/machine.conf
$(DOCKER_OLSSYNCD_BASE)_RUN_OPT += -v /etc/sonic:/etc/sonic:ro

SONIC_BUSTER_DOCKERS += $(DOCKER_OLSSYNCD_BASE)

$(DOCKER_OLSSYNCD_BASE)_DEPENDS += $(OPLINKUTIL) $(OPLINKHAL) $(OPLINKSYNCD)

$(DOCKER_OLSSYNCD_BASE)_VERSION = 1.0.0
$(DOCKER_OLSSYNCD_BASE)_PACKAGE_NAME = olssyncd

$(DOCKER_OLSSYNCD_BASE)_RUN_OPT += -v /host/warmboot:/var/warmboot
