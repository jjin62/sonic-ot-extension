#!/usr/bin/env python

########################################################################
# OT-KVM
#
# Module contains an implementation of SONiC Platform Base API and
# provides the Modules' information which are available in the platform
#
########################################################################


try:
    import os
    from sonic_platform_base.module_base import ModuleBase
    from sonic_platform.component import Component
except ImportError as e:
    raise ImportError(str(e) + "- required module not found")


class Module(ModuleBase):
    """OT-KVM Platform-specific Module class"""

    CHASSIS_MODULES = [
        ["OPS", "Optical protection switch", 1],
        ["AMP", "Optical amplifier BA", 3],
        ["AMP-P", "Optical amplifier PA", 3],
        ["SCC", "System controller card", 1]
    ]

    def __init__(self, module_index):
        ModuleBase.__init__(self)
        # Modules are 1-based in OT-KVM platforms
        self.index = module_index
        for i in range(self.CHASSIS_MODULES[self.index][2]):
            component = Component(self.index, True, i)
            self._component_list.append(component)

    def get_base_mac(self):
        """
        Retrieves the base MAC address for the module

        Returns:
            A string containing the MAC address in the format
            'XX:XX:XX:XX:XX:XX'
        """
        # In OT-KVM, individual modules doesn't have MAC address
        return '00:00:00:00:00:00'

    def get_system_eeprom_info(self):
        """
        Retrieves the full content of system EEPROM information for the module

        Returns:
            A dictionary where keys are the type code defined in
            OCP ONIE TlvInfo EEPROM format and values are their corresponding
            values.
            Ex. { '0x21':'AG9064', '0x22':'V1.0', '0x23':'AG9064-0109867821',
                  '0x24':'001c0f000fcd0a', '0x25':'02/03/2018 16:22:00',
                  '0x26':'01', '0x27':'REV01', '0x28':'AG9064-C2358-16G'}
        """
        return None

    def get_name(self):
        """
        Retrieves the name of the device

        Returns:
            string: The name of the device
        """
        return self.CHASSIS_MODULES[self.index][0]

    def get_description(self):
        """
        Retrieves the platform vendor's product description of the module

        Returns:
            A string, providing the vendor's product description of the module.
        """
        return self.CHASSIS_MODULES[self.index][1]

    def get_slot(self):
        """
        Retrieves the platform vendor's slot number of the module

        Returns:
            An integer, indicating the slot number in the chassis
        """
        return self.index + 1

    def get_type(self):
        """
        Retrieves the type of the module.

        Returns:
            A string, the module-type from one of the predefined types:
            MODULE_TYPE_SUPERVISOR, MODULE_TYPE_LINE or MODULE_TYPE_FABRIC
        """
        return ModuleBase.MODULE_TYPE_LINE

    def get_oper_status(self):
        """
        Retrieves the operational status of the module

        Returns:
            A string, the operational status of the module from one of the
            predefined status values: MODULE_STATUS_EMPTY, MODULE_STATUS_OFFLINE,
            MODULE_STATUS_FAULT, MODULE_STATUS_PRESENT or MODULE_STATUS_ONLINE
        """
        return self.MODULE_STATUS_PRESENT

    def reboot(self, reboot_type):
        """
        Request to reboot the module

        Args:
            reboot_type: A string, the type of reboot requested from one of the
            predefined reboot types: MODULE_REBOOT_DEFAULT, MODULE_REBOOT_CPU_COMPLEX,
            or MODULE_REBOOT_FPGA_COMPLEX

        Returns:
            bool: True if the request has been issued successfully, False if not
        """
        return ModuleBase.MODULE_REBOOT_DEFAULT


    def set_admin_state(self, up):
        """
        Request to keep the card in administratively up/down state.
        The down state will power down the module and the status should show
        MODULE_STATUS_OFFLINE.
        The up state will take the module to MODULE_STATUS_FAULT or
        MODULE_STAUS_ONLINE states.

        Args:
            up: A boolean, True to set the admin-state to UP. False to set the
            admin-state to DOWN.

        Returns:
            bool: True if the request has been issued successfully, False if not
        """
        return False

    def get_maximum_consumed_power(self):
        """
        Retrives the maximum power drawn by this module

        Returns:
            A float, with value of the maximum consumable power of the
            module.
        """
        return 97.23




