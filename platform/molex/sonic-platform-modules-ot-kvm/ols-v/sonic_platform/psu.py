#!/usr/bin/env python

########################################################################
# OT-KVM
#
# Module contains an implementation of SONiC Platform Base API and
# provides the PSUs' information which are available in the platform
#
########################################################################


try:
    import os
    from sonic_platform_base.device_base import DeviceBase
    from sonic_platform_base.psu_base import PsuBase
    from sonic_platform.fan import Fan
except ImportError as e:
    raise ImportError(str(e) + "- required module not found")


class Psu(PsuBase):
    """OT-KVM Platform-specific PSU class"""

    def __init__(self, psu_index):
        PsuBase.__init__(self)
        # PSU is 1-based in OT-KVM platforms
        self.index = psu_index + 1

        # Passing True to specify it is a PSU fan
        psu_fan = Fan(psu_index=self.index, psu_fan=True)
        self._fan_list.append(psu_fan)

    def get_voltage(self):
        """
        Retrieves current PSU voltage output

        Returns:
            A float number, the output voltage in volts,
            e.g. 12.1
        """
        psu_voltage = 12.00

        return psu_voltage

    def get_current(self):
        """
        Retrieves present electric current supplied by PSU

        Returns:
            A float number, electric current in amperes,
            e.g. 15.4
        """
        psu_current = 5.5

        return psu_current

    def get_power(self):
        """
        Retrieves current energy supplied by PSU

        Returns:
            A float number, the power in watts,
            e.g. 302.6
        """
        psu_power = 66.0

        return psu_power

    def get_powergood_status(self):
        """
        Retrieves the powergood status of PSU

        Returns:
            A boolean, True if PSU has stablized its output voltages and
            passed all its internal self-tests, False if not.
        """
        status = True

        return status

    def set_status_led(self, color):
        """
        Sets the state of the PSU status LED
        Args:
            color: A string representing the color with which to set the
                   PSU status LED
        Returns:
            bool: True if status LED state is set successfully, False if
                  not
        """
        # In OT-KVM, SmartFusion FPGA controls the PSU LED and the PSU
        # LED state cannot be changed from CPU.
        return True

    def get_status_led(self):
        """
        Gets the state of the PSU status LED

        Returns:
            A string, one of the predefined STATUS_LED_COLOR_* strings.
        """
        return DeviceBase.STATUS_LED_COLOR_GREEN

    def get_temperature(self):
        """
        Retrieves current temperature reading from PSU

        Returns:
            A float number of current temperature in Celsius up to
            nearest thousandth of one degree Celsius, e.g. 30.125
        """
        temperature = 25.1

        return temperature

    def get_temperature_high_threshold(self):
        """
        Retrieves the high threshold temperature of PSU

        Returns:
            A float number, the high threshold temperature of PSU in
            Celsius up to nearest thousandth of one degree Celsius,
            e.g. 30.125
        """
        return 90.0

    def get_voltage_high_threshold(self):
        """
        Retrieves the high threshold PSU voltage output

        Returns:
            A float number, the high threshold output voltage in volts,
            e.g. 12.1
        """
        voltage_high_threshold = 12.5

        return voltage_high_threshold

    def get_voltage_low_threshold(self):
        """
        Retrieves the low threshold PSU voltage output

        Returns:
            A float number, the low threshold output voltage in volts,
            e.g. 12.1
        """
        voltage_low_threshold = 11.5

        return voltage_low_threshold

    def get_maximum_supplied_power(self):
        """
        Retrieves the maximum supplied power by PSU

        Returns:
            A float number, the maximum power output in Watts.
            e.g. 1200.1
        """
        psu_maxpower = 120.0

        return psu_maxpower

    def get_psu_power_warning_suppress_threshold(self):
        """
        Retrieve the warning suppress threshold of the power on this PSU
        The value can be volatile, so the caller should call the API each time it is used.

        Returns:
            A float number, the warning suppress threshold of the PSU in watts.
        """
        return 120.0

    def get_psu_power_critical_threshold(self):
        """
        Retrieve the critical threshold of the power on this PSU
        The value can be volatile, so the caller should call the API each time it is used.

        Returns:
            A float number, the critical threshold of the PSU in watts.
        """
        return 120.0

    def get_input_voltage(self):
        """
        Retrieves current PSU voltage input

        Returns:
            A float number, the input voltage in volts,
            e.g. 12.1
        """
        return 12.1

    def get_input_current(self):
        """
        Retrieves the input current draw of the power supply

        Returns:
            A float number, the electric current in amperes, e.g 15.4
        """
        return 6.1

    def get_presence(self):
        """
        Retrieves the presence of the Power Supply Unit (PSU)

        Returns:
            bool: True if PSU is present, False if not
        """
        return True

    def get_model(self):
        """
        Retrieves the part number of the PSU

        Returns:
            string: Part number of PSU
        """
        # For Serial number "US-01234D-54321-25A-0123-A00", the part
        # number is "01234D"
        psu_partno = '01234D'
        return psu_partno

    def get_serial(self):
        """
        Retrieves the serial number of the PSU

        Returns:
            string: Serial number of PSU
        """
        # Sample Serial number format "US-01234D-54321-25A-0123-A00"
        psu_serialno = 'OLS-V-PSU-01234D-{}-A0'.format(self.index)
        return psu_serialno

    def get_revision(self):
        """
        Retrieves the hardware revision of the device

        Returns:
            string: Revision value of device
        """
        psu_rev = 'A0'
        return psu_rev