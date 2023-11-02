SONIC OT-KVM Demo Instructions
--------

A team at Molex is developing to expand SONiC's support to optical line system. 

This doc contains the procedure to run and test the SONiC-OT KVM image, the prototype the team currently has.

## Environment
1. Install Ubuntu KVM tools

```bash
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager 
```

2. Check CPU virtualization support

```bash
kvm-ok
```
checks KVM support.

If the host itself is a VM as well, 
```bash
cat /sys/module/kvm_<cpu_brand>/parameters/nested
```
checks nested virtualization support

3. Copy the SONiC image to host. The package contains two files:
    - sonic-ot-kvm.img.gz      --- compressed SONiC image 
    - sonic-ot-kvm.xml         --- virsh SONiC kvm config file

4. Decompress the image
```bash
gunzip sonic-ot-kvm.img.gz
```

5. Customize fields of the config file per need

In the xml config file, multiple fields, can be customized per need. This includs RAM, emulator path, SONiC image path, telnet port. 
```xml
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  <name>sonic-ot-kvm</name>
  <memory unit='KiB'>2048000</memory>
  <currentMemory unit='KiB'>2048000</currentMemory>
  <vcpu placement='static'>4</vcpu>
  <resource>
    <partition>/machine</partition>
  </resource>
  <os>
    <type arch='x86_64' machine='pc-i440fx-1.5'>hvm</type>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
  </features>
  <clock offset='utc'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>restart</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='writeback'/>
      <source file='/home/jikeyu/sonic-buildimage/target/sonic-vs.img'/>
      <target bus='virtio' dev='vda'/>
    </disk>
    <serial type='tcp'>
      <source host='127.0.0.1' mode='bind' service='7000'/>
      <target port='0'/>
      <protocol type='telnet'/>
    </serial>
    <interface type='user'>
        <model type='e1000' />
    </interface>
    <interface type='ethernet' />
    <controller type='usb' index='0'/>
    <memballoon model='virtio'>
      <alias name='balloon0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
    </memballoon>
  </devices>
  <seclabel type='dynamic' model='apparmor' relabel='yes'/>
  <qemu:commandline>
   <qemu:arg value='-net'/>
   <qemu:arg value='user,hostfwd=tcp:127.0.0.1:3040-:22'/>
  </qemu:commandline> 
</domain>
```

## Running SONiC-OT KVM
1. Create SONiC KVM

Make sure the SONiC image file path in the config xml is correct.
```bash
sudo virsh create <path-to-sonic-ot-kvm.xml>
```

If you'd like to check if KVM has started, run
```bash
virsh list
```

2. Connect and login

To connect to the SONiC KVM, run
```bash
telnet 127.0.0.1 7000
```
If you have changed the port in the config xml, use the correct port here.

The username and password for the prototype image is admin and YourPaSsWoRd, which are the default of SONiC.

3. Shutdown KVM SONiC

If you would like to remote the KVM, run
```bash
sudo virsh destroy sonic-ot-kvm
```
If you have changed the name of the KVM in the config xml, use the correct name here.


## CLI Support for Optical Line System
In ```sonic-mgmt-framework```, we have added CLIs for openconfigoptical transport yang model. For now, it includes ```openconfig-optical-attenuator.yang``` and ```openconfig-optical-amplifier.yang```. 

Config data is stored in the relevant tables in CONFIG_DB (table 4) of Redis.

### Features
- Login CLI interface
- Set/get attenuators
- Set/get amplifier

### Log in CLI
The following operations are in SONiC.
1. make sure mgmt-framework and olssyncd containers are up

```bash
docker ps -a
```

2. Enter the CLI via the shell of mgmt-framework container.

```bash
docker exec -it mgmt-framework bash
/usr/sbin/cli/clish_start
```

3. In ```sonic#``` (read-only) mode, check config and status

```
show attenuator
```

4. Enter ```sonic(config)#``` mode

```
configure terminal
amplifier ba apr-enable disable
exit
```
```exit``` exits config mode and returns to ```sonic#``` mode.

5. Return to bash
```
exit
```

### Commands
```bash
# in sonic# mode
show attenuator
show amplifier <pa/ba>
```
```bash
# in sonic(config)# mode
attenuator <voa1/voa2> attn <value>
amplifier <pa/ba> enabled <enable/disable>
amplifier <pa/ba> target-gain <value>
amplifier <pa/ba> target-gain-tilt <value>
amplifier <pa/ba> gain-range  <low/mid/high/fixed>
amplifier <pa/ba> amp-mode <constant-power/constant-gain>
```

### Log
```
show logging
```

## REST API for Optical Support
REST API follows RESTCONF protocol

In ```sonic-mgmt-common```, REST APIs generated from openconfig optical transport yang model are added, including ```openconfig-optical-attenuator.yang``` and ```openconfig-optical-amplifier.yang```.

### Feature
- Support ```openconfig-optical-attenuator.yaml``` REST APIs
- Support ```openconfig-optical-amplifier.yaml``` REST APIs

## Redis
We have added the following tables to support data of optical line system, based on openconfig optical transport yang models. 
- For CONFIG_DB (DB 4)
  - ATTENUATOR_TABLE|VOA1
  - ATTENUATOR_TABLE|VOA2
  - AMPLIFIER_TABLE|PA
  - AMPLIFIER_TABLE|BA
- For STATE_DB (DB 6)
  - ATTENUATOR_STATE_TABLE|VOA1
  - ATTENUATOR_STATE_TABLE|VOA2
  - AMPLIFIER_STATE_TABLE|PA
  - AMPLIFIER_STATE_TABLE|BA

### Redis debug
One can directly use redis-cli to test olssyncd, without invoking the SONiC CLI
```bash
# Select the fourth redis db, which is the config_db 
select 4 

# Check current VOA1 config 
hgetall ATTENUATOR_TABLE|VOA1 

# Check current VOA2 config 
hgetall ATTENUATOR_TABLE|VOA2 

# Select the sixth redis db, which is the state_db 
select 6 

# Check current VOA1 state, the attn (almost) matches config 
hgetall ATTENUATOR_TABLE|VOA1 

# Check current VOA2 state, the attn (almost) matches config 
hgetall ATTENUATOR_TABLE|VOA2 

# Go back to config_db 
Select 4  

# Change VOA1 attn 
hset ATTENUATOR_TABLE|VOA1 attenuation <new_value> 

# Change VOA2 attn 
hset ATTENUATOR_TABLE|VOA2 attenuation <new_value> 

# Go to state_db 
Select 6 

# VOA1 attn config change is reflected in state 
hgetall ATTENUATOR_TABLE|VOA1 

# VOA2 attn config change is reflected in state 
hgetall ATTENUATOR_TABLE|VOA2
```

To further check the config has been received by the virtual hardware:
```bash
# enter olssyncd, invoke bash
docker exec -it olssyncd bash

# print out the virtual hardware's status
cat /var/SPIOaConfig.json
```
