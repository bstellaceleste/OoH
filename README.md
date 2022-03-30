# Artifact-Eval

Out of Hypervisor (OoH) is a new virtualization research axis. Instead of emulating full virtual hardware inside a VM to support a hypervisor, the OoH principle is to individually expose current hypervisor-oriented hardware virtualization features to the guest OS. This way, guest’s processes could also take benefit from those features. We illustrate OoH with Intel PML (Page modification Logging), a feature that allows efficient dirty page tracking to improve VM live migration. Because dirty page tracking is at the heart of many essential tasks including process checkpointing (e.g., CRIU) and concurrent garbage collection (e.g, Boehm GC), OoH exposes PML to accelerate these tasks in the guest. We present two OoH solutions namely Shadow PML (SPML) and
Extended PML (EPML) that we integrated into CRIU and Boehm GC. Evaluation results showed that EPML speeds up CRIU checkpointing by about `13x` and Boehm garbage collection by up to 6× compared to SPML, /proc, and userfaultfd while reducing the impact of monitoring applications by about `16x`.

OoH is implemented using Xen 4.10.0 hypervisor, Linux 4.15.0 guest OS, and BOCHS 2.6.11 Intel x86 emulator (only for EPML, which extends the hardware), Boehm Garbage Collector and CRIU.

This repo provides the tools aand directives to evaluate SPML and EPML implementations.

## Shadow PML (SPML)

To facilitate the tests, the following material is provided:
- [Xen 4.10 patched](xen-OoH)
- [Linux 4.15 patched and compiled](https://s3.console.aws.amazon.com/s3/object/artifacteval?region=us-east-2&prefix=linux-OoH.zip). We rather provide the compiled version (with the vmlinuz image) since the compilation can take a while (usually more than an hour). The user can however find the patch [here](linux-OoH/patch).
- The use case [Boehm GC](bohem-OoH) patched
- A [VM image](https://s3.console.aws.amazon.com/s3/object/artifacteval?region=us-east-2&prefix=vm.raw) with the Xen tools installed for PML activation from the guest.

### Environment Setup

#### Prerequisites
1. Operating System: `Ubuntu 18.04`

2. CPU brand: `Intel` 

2. Support for PML feature: 
    * `sudo modprobe msr`
    * `sudo rdmsr 0x48BH` : if PML is supported, bit at position **49** will be set

3. Dependencies for Xen:
   ```
   sudo apt update
   sudo apt-get build-dep xen
   sudo apt install libc6-dev libglib2.0-dev libyajl-dev yajl-tools libbz2-dev bison flex zlib1g-dev git-core debhelper debconf-utils debootstrap fakeroot gcc make binutils  liblz-dev  python-dev libncurses-dev libcurl4-openssl-dev libx11-dev uuid-dev libaio-dev pkg-config bridge-utils udev bison flex gettext bin86 bcc iasl gcc-multilib libperl-dev libgtk2.0-dev
   ```
   
#### Xen Installation
> All commands in sudo (_this might take a while_)
```
./configure
make
make install
ldconfig
update-grub
```
After this, reboot on Xen (select in the grub `Ubuntu with Xen hypervisor`.
To start Xen demon, type the following commands: `sudo /etc/init.d/xencommons start`.
To verify, you can check either for the Xen info `sudo xl info` or the list of VMs `sudo xl li`.

#### VM Creation
A configuration [file](vm.cfg) is provided to launch the VM: `sudo xl create vm.cfg`
