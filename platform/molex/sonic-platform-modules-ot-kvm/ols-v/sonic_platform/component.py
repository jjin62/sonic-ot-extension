#!/usr/bin/env python

########################################################################
# OT-KVM
#
# Module contains an implementation of SONiC Platform Base API and
# provides the Components' (e.g., BIOS, CPLD, FPGA, etc.) available in
# the platform
#
########################################################################

try:
    import json
    import os
    import re
    import subprocess
    import tarfile
    from sonic_platform_base.component_base import ComponentBase
except ImportError as e:
    raise ImportError(str(e) + "- required module not found")


class Component(ComponentBase):
    """OT-KVM Platform-specific Component class"""

    CHASSIS_COMPONENTS = [
        ["BIOS", ("Performs initialization of hardware components during "
                  "booting"), "1.01"],
        ["FPGA", ("Platform management controller for on-board temperature "
                  "monitoring, in-chassis power, Fan and LED control"), "99.99.0016"],
        ["CPLD", "Used for managing IO modules, SFP+ modules and system LEDs", "0.01.0006"],
        ["OPS", "Optical protection switch", "0.01.0002"],
        ["AMP", "Optical amplifier BA", "0.01.0037"],
        ["AMP-P", "Optical amplifier PA", "0.01.0037"],
        ["SCC", "System controller card", "0.00.0002"],
        ["ONIE", "Open Network Install Environment", "2022.08"]
    ]
    MODULE_COMPONENTS = [
        [
            ["OPS", "Optical protection switch", "0.01.0002"]
        ],
        [
            ["EDFA", "AMP BA", "9.99.0131"],
            ["OCM", "AMP OCM", "0.02.0034"],
            ["OTDR", "AMP OTDR", "0.01.0059"]
        ],
        [
            ["EDFA-P", "AMP-P PA", "9.99.0131"],
            ["OCM-P", "AMP-P OCM", "0.02.0034"],
            ["OTDR-P", "AMP-P OTDR", "0.01.0059"]
        ],
        [
            ["SCC", "SCC main card", "0.00.0002"]
        ]
    ]

    def __init__(self, component_index=0,
                 is_module=False, iom_index=0, i2c_line=0, dependency=None):

        ComponentBase.__init__(self)
        self.is_module_component = is_module
        self.dependency = dependency

        if self.is_module_component:
            self.index = iom_index
            self.name = self.MODULE_COMPONENTS[component_index][iom_index][0]
            self.description = self.MODULE_COMPONENTS[component_index][iom_index][1]
            self.version = self.MODULE_COMPONENTS[component_index][iom_index][2]
        else:
            self.index = component_index
            self.name = self.CHASSIS_COMPONENTS[self.index][0]
            self.description = self.CHASSIS_COMPONENTS[self.index][1]
            self.version = self.CHASSIS_COMPONENTS[self.index][2]

    def get_name(self):
        """
        Retrieves the name of the component

        Returns:
            A string containing the name of the component
        """
        return self.name

    def get_description(self):
        """
        Retrieves the description of the component

        Returns:
            A string containing the description of the component
        """
        return self.description

    def get_firmware_version(self):
        """
        Retrieves the firmware version of the component

        Returns:
            A string containing the firmware version of the component
        """
        return self.version

    def get_available_firmware_version(self, image_path):
        """
        Retrieves the available firmware version of the component

        Note: the firmware version will be read from image

        Args:
            image_path: A string, path to firmware image

        Returns:
            A string containing the available firmware version of the component
        """
        return self.version

    def install_firmware(self, image_path):
        """
        Installs firmware to the component

        Args:
            image_path: A string, path to firmware image

        Returns:
            A boolean, True if install was successful, False if not
        """
        return False

    def update_firmware(self, image_path):
        """
        Updates firmware of the component

        This API performs firmware update: it assumes firmware installation and loading in a single call.
        In case platform component requires some extra steps (apart from calling Low Level Utility)
        to load the installed firmware (e.g, reboot, power cycle, etc.) - this will be done automatically by API

        Args:
            image_path: A string, path to firmware image

        Returns:
            Boolean False if image_path doesn't exist instead of throwing an exception error
            Nothing when the update is successful

        Raises:
            RuntimeError: update failed
        """
        return True

    def auto_update_firmware(self, image_path, boot_type):
        """
        Updates firmware of the component

        This API performs firmware update automatically based on boot_type: it assumes firmware installation
        and/or creating a loading task during the reboot, if needed, in a single call.
        In case platform component requires some extra steps (apart from calling Low Level Utility)
        to load the installed firmware (e.g, reboot, power cycle, etc.) - this will be done automatically during the reboot.
        The loading task will be created by API.

        Args:
            image_path: A string, path to firmware image
            boot_type: A string, reboot type following the upgrade
                         - none/fast/warm/cold

        Returns:
            Output: A return code
                return_code: An integer number, status of component firmware auto-update
                    - return code of a positive number indicates successful auto-update
                        - status_installed = 1
                        - status_updated = 2
                        - status_scheduled = 3
                    - return_code of a negative number indicates failed auto-update
                        - status_err_boot_type = -1
                        - status_err_image = -2
                        - status_err_unknown = -3

        Raises:
            RuntimeError: auto-update failure cause
        """
        return 1
