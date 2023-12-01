# install ols package for ols container

PACKAGE = ols
$(PACKAGE)_REPOSITORY = molex/ols  #need build a docker repository
$(PACKAGE)_VERSION = 1.0.0
SONIC_PACKAGES += $(PACKAGE)

