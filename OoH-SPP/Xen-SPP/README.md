# Xen-SPP

Use in native mode (SPP emulation)

This version of Xen is compatible with the version of [Linux](../Linux-SPP) present in this repo, because the SPP pools of LeanGuard are defined accordingly (depending on the subpage protection pattern: 1 over 2, 1 over 4, etc.)


Install from sources:

    sudo apt update
    sudo apt-get build-dep xen

    Install dependencies:
    sudo apt install libc6-dev libglib2.0-dev libyajl-dev yajl-tools libbz2-dev bison flex zlib1g-dev git-core texinfo   debhelper debconf-utils debootstrap fakeroot gcc make binutils  liblz-dev  python-dev libncurses-dev libcurl4-openssl-dev libx11-dev uuid-dev libyajl-dev libaio-dev  libglib2.0-dev pkg-config  bridge-utils udev bison flex gettext bin86 bcc iasl markdown git gcc-multilib  texinfo libperl-dev libgtk2.0-dev

    Commands to execute inside the directory (if you have error on corresponding folders -- otherwise just compile directly)

    sudo rm -r tools/qemu-xen-dir/ tools/qemu-xen-traditional-dir/ tools/qemu-xen-build/
    
download the original archive [xen-4.10.0](https://downloads.xenproject.org/release/xen/4.10.0/xen-4.10.0.tar.gz), uncompress it and type : 
    
    cp -r xen-4.10.0_clean/tools/hotplug xen-4.10.0_modified/tools
    ./configure
    make world
    make install
    ldconfig
    update-grub

    Reboot on Xen


