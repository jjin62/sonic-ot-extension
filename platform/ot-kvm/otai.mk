LIBOTAI_VERSION = 1.0.1
OTKVM_LIBOTAI_DEB = libotai-mlx-$(LIBOTAI_VERSION)-amd64.deb
$(OTKVM_LIBOTAI_DEB)_URL = "https://raw.githubusercontent.com/oplinkoms/sonic-libmlx/main/$(OTKVM_LIBOTAI_DEB)"

SONIC_ONLINE_DEBS += $(OTKVM_LIBOTAI_DEB)