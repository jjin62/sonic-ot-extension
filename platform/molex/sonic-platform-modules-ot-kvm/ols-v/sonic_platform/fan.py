#!/usr/bin/env python

########################################################################
# OT-KVM
#
# Module contains an implementation of SONiC Platform Base API and
# provides the Fans' information which are available in the platform.
#
########################################################################

import os.path

try:
    from sonic_platform_base.device_base import DeviceBase
    from sonic_platform_base.fan_base import FanBase
except ImportError as e:
    raise ImportError(str(e) + "- required module not found")

MAX_OLS_V_PSU_FAN_SPEED = 18000
MAX_OLS_V_FAN_SPEED = 16000


class Fan(FanBase):
    """OT-KVM Platform-specific Fan class"""

    def __init__(self, fantray_index=1, psu_index=1, psu_fan=False, dependency=None):
        FanBase.__init__(self)
        self.is_psu_fan = psu_fan
        if not self.is_psu_fan:
            self.fantrayindex = fantray_index
            self.dependency = dependency
            self.max_fan_speed = MAX_OLS_V_FAN_SPEED
        else:
            self.psuindex = psu_index
            self.max_fan_speed = MAX_OLS_V_PSU_FAN_SPEED


    def get_direction(self):
        """
        Retrieves the fan airflow direction
        Returns:
            A string, either FAN_DIRECTION_INTAKE or FAN_DIRECTION_EXHAUST
            depending on fan direction

        Notes:
            In OT-KVM platforms,
            - Forward/Exhaust : Air flows from Port side to Fan side.
            - Reverse/Intake  : Air flows from Fan side to Port side.
        """
        direction = [self.FAN_DIRECTION_INTAKE, self.FAN_DIRECTION_EXHAUST]

        return direction[1]

    def get_speed(self):
        """
        Retrieves the speed of fan
        Returns:
            int: percentage of the max fan speed
        """
        speed = 60
        if self.is_psu_fan:
            speed = 50

        return speed

    def get_target_speed(self):
        """
        Retrieves the target (expected) speed of the fan
        Returns:
            An integer, the percentage of full fan speed, in the range 0 (off)
                 to 100 (full speed)
        """
        return self.get_speed()

    def get_speed_tolerance(self):
        """
        Retrieves the speed tolerance of the fan
        Returns:
            An integer, the percentage of variance from target speed which is
        considered tolerable
        """
        tolerance = 10

        return tolerance

    def set_speed(self, speed):
        """
        Set fan speed to expected value
        Args:
            speed: An integer, the percentage of full fan speed to set fan to,
                   in the range 0 (off) to 100 (full speed)
        Returns:
            bool: True if set success, False if fail.
        """
        # Fan speeds are controlled by Smart-fussion FPGA.
        return True

    def set_status_led(self, color):
        """
        Set led to expected color
        Args:
            color: A string representing the color with which to set the
                   fan module status LED
        Returns:
            bool: True if set success, False if fail.
        """
        # No LED available for FanTray and PSU Fan
        # Return True to avoid thermalctld alarm.
        return True

    def get_status_led(self):
        """
        Gets the state of the Fan status LED

        Returns:
            A string, one of the predefined STATUS_LED_COLOR_* strings.
        """
        # No LED available for FanTray and PSU Fan
        return DeviceBase.STATUS_LED_COLOR_GREEN

    def get_name(self):
        """
        Retrieves the fan name
        Returns:
            string: The name of the device
        """
        if self.is_psu_fan:
            return "PSU{} Fan".format(self.psuindex)
        else:
            return "FanTray{}-Fan1".format(self.fantrayindex)

    def get_model(self):
        """
        Retrieves the part number of the FAN
        Returns:
            string: Part number of FAN
        """
        if self.is_psu_fan:
            return 'PSU-01234D'
        else:
            return 'FAN-01234D'

    def get_serial(self):
        """
        Retrieves the serial number of the FAN
        Returns:
            string: Serial number of FAN
        """
        if self.is_psu_fan:
            return 'OLS-V-PSU-01234D-{}-A0'.format(self.psuindex)
        else:
            return 'OLS-V-FAN-01234D-{}-A0'.format(self.fantrayindex)

    def get_presence(self):
        """
        Retrieves the presence of the FAN
        Returns:
            bool: True if fan is present, False if not
        """
        presence = True

        return presence

    def get_status(self):
        """
        Retrieves the operational status of the FAN
        Returns:
            bool: True if FAN is operating properly, False if not
        """
        status = True

        return status

    def get_position_in_parent(self):
        """
        Retrieves 1-based relative physical position in parent device.
        Returns:
            integer: The 1-based relative physical position in parent
            device or -1 if cannot determine the position
        """
        return 1

    def is_replaceable(self):
        """
        Indicate whether Fan is replaceable.
        Returns:
            bool: True if it is replaceable.
        """
        return False

