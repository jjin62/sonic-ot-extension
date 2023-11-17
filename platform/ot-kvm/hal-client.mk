HALCLIENT_VERSION = 1.0.0
OTKVM_HALCLIENT_DEB = libhalplatformclient-mlx-$(HALCLIENT_VERSION)-amd64.deb
$(OTKVM_HALCLIENT_DEB)_URL = "https://raw.githubusercontent.com/oplinkoms/sonic-libmlx/main/$(OTKVM_HALCLIENT_DEB)"

$(OTKVM_HALCLIENT_DEB)_DEPENDS += $(PYTHON3_THRIFT_0_14_1)
$(OTKVM_HALCLIENT_DEB)_RDEPENDS += $(PYTHON3_THRIFT_0_14_1)

SONIC_ONLINE_DEBS += $(OTKVM_HALCLIENT_DEB)