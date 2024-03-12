OT_KVM_THRIFT_ROOT_URL = https://raw.githubusercontent.com/oplinkoms/sonic-libmlx/main

OT_KVM_THRIFT_LIB_DEB = libthrift_14_amd64.deb
$(OT_KVM_THRIFT_LIB_DEB)_URL = "$(OT_KVM_THRIFT_ROOT_URL)/$(OT_KVM_THRIFT_LIB_DEB)"

OT_KVM_THRIFT_LIB_DEV_DEB = libthrift-dev_14_amd64.deb
$(OT_KVM_THRIFT_LIB_DEV_DEB)_URL = "$(OT_KVM_THRIFT_ROOT_URL)/$(OT_KVM_THRIFT_LIB_DEV_DEB)"

OT_KVM_THRIFT_PYTHON3_DEB = python3-thrift_14_amd64.deb
$(OT_KVM_THRIFT_PYTHON3_DEB)_URL = "$(OT_KVM_THRIFT_ROOT_URL)/$(OT_KVM_THRIFT_PYTHON3_DEB)"

SONIC_ONLINE_DEBS += $(OT_KVM_THRIFT_LIB_DEB) $(OT_KVM_THRIFT_LIB_DEV_DEB) $(OT_KVM_THRIFT_PYTHON3_DEB)