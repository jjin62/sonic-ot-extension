# rules to define remote packages that need to be installed
# during SONiC image build

DOCKER_OLS = docker-ols
$(DOCKER_OLS)_REPOSITORY = molex/docker-ols
$(DOCKER_OLS)_VERSION = 1.0.0
SONIC_PACKAGES += $(DOCKER_OLS)
$(DOCKER_OLS)_DEFAULT_FEATURE_STATE_ENABLED = y


