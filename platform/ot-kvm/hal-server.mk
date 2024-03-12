HALSERVER_VERSION = 1.0.0
OTKVM_HALSERVER_DEB = libhal-mlx-ot-kvm-$(HALSERVER_VERSION)-amd64.deb
$(OTKVM_HALSERVER_DEB)_URL = "https://raw.githubusercontent.com/oplinkoms/sonic-libmlx/main/$(OTKVM_HALSERVER_DEB)"

$(OTKVM_HALSERVER_DEB)_DEPENDS += $(OT_KVM_THRIFT_LIB_DEB) $(OT_KVM_THRIFT_LIB_DEV_DEB)
$(OTKVM_HALSERVER_DEB)_RDEPENDS += $(OT_KVM_THRIFT_LIB_DEB)

SONIC_ONLINE_DEBS += $(OTKVM_HALSERVER_DEB)