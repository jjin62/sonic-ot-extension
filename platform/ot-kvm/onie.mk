ONIE_RECOVERY_IMAGE = onie-recovery-x86_64-ot-kvm_x86_64-r0.iso
$(ONIE_RECOVERY_IMAGE)_URL = "https://github.com/oplinkoms/onie/raw/2018.11br/build/images/$(ONIE_RECOVERY_IMAGE)"

ONIE_RECOVERY_KVM_4ASIC_IMAGE = onie-recovery-x86_64-kvm_x86_64_4_asic-r0.iso
$(ONIE_RECOVERY_KVM_4ASIC_IMAGE)_URL = "https://sonicstorage.blob.core.windows.net/packages/onie/onie-recovery-x86_64-kvm_x86_64_4_asic-r0.iso?sv=2020-04-08&st=2021-08-27T22%3A41%3A07Z&se=2030-08-28T22%3A41%3A00Z&sr=b&sp=r&sig=zyaX7rHnE5jXldpgrnWq1nvsfmMTrVCSuESZqrIxDLc%3D"

ONIE_RECOVERY_KVM_6ASIC_IMAGE = onie-recovery-x86_64-kvm_x86_64_6_asic-r0.iso
$(ONIE_RECOVERY_KVM_6ASIC_IMAGE)_URL = "https://sonicstorage.blob.core.windows.net/packages/onie/onie-recovery-x86_64-kvm_x86_64_6_asic-r0.iso?sv=2020-04-08&st=2021-08-27T22%3A42%3A24Z&se=2030-08-28T22%3A42%3A00Z&sr=b&sp=r&sig=RqbtHJt8Hvy7j78jt3TgXo27T7zjdUDfSxqmOID1YUU%3D"

SONIC_ONLINE_FILES += $(ONIE_RECOVERY_IMAGE) $(ONIE_RECOVERY_KVM_4ASIC_IMAGE) $(ONIE_RECOVERY_KVM_6ASIC_IMAGE)
