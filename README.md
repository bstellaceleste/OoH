# OoH: Out of Hypervisor

Out of Hypervisor (OoH) is a new virtualization research axis. Instead of emulating full virtual hardware inside a VM to support a hypervisor, the OoH principle is to individually expose current hypervisor-oriented hardware virtualization features to the guest OS. This way, guest’s processes could also take benefit from those features. We illustrate OoH with Intel PML (Page modification Logging), a feature that allows efficient dirty page tracking to improve VM live migration. Because dirty page tracking is at the heart of many essential tasks including process checkpointing (e.g., CRIU) and concurrent garbage collection (e.g, Boehm GC), OoH exposes PML to accelerate these tasks in the guest. We present two OoH solutions namely Shadow PML (SPML) and
Extended PML (EPML) that we integrated into CRIU and Boehm GC. Evaluation results showed that EPML speeds up CRIU checkpointing by about `13x` and Boehm garbage collection by up to 6× compared to SPML, /proc, and userfaultfd while reducing the impact of monitoring applications by about `16x`.

OoH is implemented using Xen 4.10.0 hypervisor, Linux 4.15.0 guest OS, and BOCHS 2.6.11 Intel x86 emulator (only for EPML, which extends the hardware), Boehm Garbage Collector and CRIU.

This repo provides tools and guidelines for testing SPML and EPML implementations.

# Overview

We present two solutions of OoH, namely Shadow PML (noted SPML) and Extended PML (noted EPML). SPML requires no hardware modification, while EPML slightly extends the hardware for better performance. The following figure presents the architecture of the two solutions. In the guest, we provide OoH as a userspace I/O (UIO) driver composed of a kernel module (OoH Module) and a userspace library (OoH Lib). At load time, the former does a set of initialization operations, including ring buffer (RB) allocation that is shared with userspace (and the hypervisor in SMPL only). Tracker uses OoH Lib to register the PID of Tracked with OoH Module. From there on, the processor can log dirty pages’ addresses to a 512KB PML buffer, which is copied to RB once full. Relying on OoH Lib, Tracker can periodically fetch the collected addresses to achieve its goal (e.g., checkpointing). EPML differs from SPML in two ways: (1) With EPML, the processor also logs GVAs, thus avoiding costly reverse mapping in OhH Lib; (2) With EPML, the guest kernel can directly deal with the processor, thus avoiding costly hypercalls. 
![design](design.png)

## Shadow PML (SPML)

To facilitate the tests, the following material is provided (and should be downloaded):
> Most of the ressources are stored on [Amazon S3](https://s3.console.aws.amazon.com/s3/buckets/artifacteval?region=us-east-2&tab=objects#). You should sign in as an **IAM** user, with the following information: 
> 
> Account ID: **581028953800** 
> 
> User Name: **Artifact-Evaluators**
> 
> Password: **ArtifactSC22**

- [Xen 4.10 patched](xen-OoH)
- [Linux 4.15 patched and compiled](https://s3.console.aws.amazon.com/s3/object/artifacteval?region=us-east-2&prefix=linux-OoH.zip). We rather provide the compiled version (with the vmlinuz image) since the compilation can take some time (usually more than an hour). The user can however find the patch [here](linux-OoH/patch).
- The use case [Boehm GC](https://github.com/ivmai/bdwgc) already [patched](bohem-OoH), and [datasets](https://s3.console.aws.amazon.com/s3/object/artifacteval?region=us-east-2&prefix=datasets.zip) for its applications.
- A [VM image](https://s3.console.aws.amazon.com/s3/object/artifacteval?region=us-east-2&prefix=vm.raw) with the Xen tools installed for PML activation from the guest.

### Environment Setup

#### Prerequisites
1. Operating System: `Ubuntu 18.04`

2. CPU Brand: `Intel` 

2. Support for PML feature: 
    * `sudo modprobe msr`
    * `sudo rdmsr 0x48BH` : if PML is supported, bit at position **49** will be set.

3. Dependencies for Xen, ssh, and nfs:
   ```
   sudo apt update
   sudo apt build-dep xen
   sudo apt install libc6-dev libglib2.0-dev libyajl-dev yajl-tools libbz2-dev bison flex zlib1g-dev git-core debhelper debconf-utils debootstrap fakeroot gcc make binutils  liblz-dev  python-dev libncurses-dev libcurl4-openssl-dev libx11-dev uuid-dev libaio-dev pkg-config bridge-utils udev bison flex gettext bin86 bcc iasl gcc-multilib libperl-dev libgtk2.0-dev
   sudo apt install openssh-common openssh-client
   sudo apt install nfs-common nfs-kernel-server
   ```
4. Sources: [download](https://github.com/bstellaceleste/Artifact-Eval/archive/refs/heads/SPML.zip) the zip file of the repo and uncompress it into **/mnt/tmp**. It is important that the root directory of your tests is **/mnt/tmp** because it is the path used to compile Linux and to write all the scripts and, since it is independent of the user's `$HOME` environment it allows easier portability and deployment.
   
#### Xen Installation
> All commands in sudo (_compilation and installaion might take a while_)
```
cd /mnt/tmp/xen-OoH
./configure
make
make install
ldconfig
update-grub
```
After this, reboot on Xen (select in the grub `Ubuntu with Xen hypervisor`).
To start Xen demon, type the following commands: `sudo /etc/init.d/xencommons start`.
To verify, you can check either for the Xen info `sudo xl info` or the list of VMs `sudo xl li`.

#### VM Creation
A configuration [file](vm.cfg) is provided to create a VM.

You must first fill the correct **absolute** path to the VM image.

After which you can use the following command: `sudo xl create vm.cfg`. You must see `ooh` if you check for the list of VMs (`sudo xl li`).

To access the VM, you need to create and configure a bridge:
```
sudo brctl addbr xenbr0
sudo ifconfig xenbr0 10.0.0.1
```
To provide the VM with network access to the Internet, use the [routing](routing.sh) script in the repo. If your network interface is `ethX` for example, then use the script this way: `sudo routing.sh ethX`.

### Testing

#### Accessing the VM
When the VM has completely booted (its state is `r` -for _ready_- in the list), you can access it via ssh: `ssh stella@10.0.0.2`. The password is `toto`.

The VM boots by default on the modified kernel, and in the `$HOME` directory there is a config script that automatically mounts the linux-OoH and the boehm directories respectively to `/mnt/tmp/linux-4.15-rc7` and `$HOME/boehm` inside the VM.

#### Compiling Boehm GC
Boehm is compiled in the VM (from `$HOME`) as follows:
```
cd boehm
sudo ./configure --disable-threads --prefix=/home/stella/boehm/Use_Case_Apps/phoenix-2.0 --enable-static --enable-checksums --enable-mmap --disable-munmap --disable-shared
sudo make
sudo make install
```
Libraries are installed to the `lib` dir.
Once installed, export GC-specific environment variables to enable incremental collection and statistics prints:
```
GC_ENABLE_INCREMENTAL='GC_ENABLE_INCREMENTAL'
GC_PRINT_VERBOSE_STATS='GC_PRINT_VERBOSE_STATS'
GC_USE_GETWRITEWATCH='GC_USE_GETWRITEWATCH'
export GC_ENABLE_INCREMENTAL
export GC_PRINT_VERBOSE_STATS
export GC_USE_GETWRITEWATCH
```
> Note: These variables should be exported at each reboot, otherwise defined in an env file.

#### Testing Boehm GC with [Phoenix](https://github.com/kozyraki/phoenix) Applications and [GCBench](https://hboehm.info/gc/gc_bench/)
Now that our environment is set and the GC that integrates SPML is compiled, we can test it using the Phoenix benchmark suite.

**1. Load OoH kernel module**

The first thing is to load the OoH kernel module:

`su (password: toto)`
> You should be in root mode -do not use sudo-
```
cd /mnt/tmp/linux-4.15-rc7/vtf-uio_vS0
make
insmod uio_vtf
```
If the module has been successfully loaded, you must find in `/dev` a device named **`uio0`**.

**2. Compile Phoenix applications**

From the `boehm` directory:
```
cd Use_Case_Apps/phoenix-2.0/
sudo make
```

**3. Execute applications**

All applications are in the `tests` dir, and the datasets required may have been previously downloaded in the _prerequisites_ section.
> From boehm-OoH/Use_Case_Apps

First, uncompress it dataset folder in the corresponding bench dir:
```
unzip -d . datasets
unzip -d test/histogram/dataset datasets/dataset_hist
unzip -d test/string_match/dataset datasets/dataset_string
unzip -d test/word_count/dataset datasets/dataset_word
```

   * histogram
     ```
     cd tests/histogram
     unzip -d . dataset.zip
     ./histogram dataset/large.bmp
     ```
   * kmeans
     ```
     cd tests/kmeans
     ./kmeans -d 5000 -c 5000 -p 5000 -s 100
     ```
   * pca
     ```
     cd tests/pac
     ./pca -r 10000 -c 5000 -s 200
     ```
   * string_match
     ```
     cd tests/string_match
     unzip -d . dataset.zip
     ./string_match dataset/key_file_200MB.txt
     ```
   * word_count
     ```
     cd tests/word_count
     unzip -d . dataset.zip
     ./word_count dataset/word_100MB.txt
     ```
   * GCBench
     ```
     cd gcbench
     gcc -o GCBench GCBench.c
     ./GCBench
     ```

#### Comparison With `/proc`

`/proc` is the default technique implemented in Boehm. To perform tests with the latter:
   * edit the file `boehm-OoH/include/private/gcconfig.h`
   * comment the lines:
   ```
   #       ifndef PML_VDB
   #         define PML_VDB
   #       endif
   ```
   * recompile boehm as previously explained and re-execute the applications.


## Extended PML (EPML)

The use of EPML is more tricky since it should be emulated.

We use in our implementation the [Bochs](https://sourceforge.net/projects/bochs/files/bochs/2.6.11/) emulator for which we provide the [patched](Bochs-OoH) version.
