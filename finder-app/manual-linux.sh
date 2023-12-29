#!/bin/bash
# Script outline to install and build kernel.
# Author: Siddhant Jajoo.

set -e
set -u

OUTDIR=/tmp/aeld
KERNEL_REPO=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
KERNEL_VERSION=v5.1.10
BUSYBOX_VERSION=1_33_1
FINDER_APP_DIR=$(realpath $(dirname $0))
ARCH=arm64
CROSS_COMPILE=aarch64-none-linux-gnu-

if [ $# -lt 1 ]
then
	echo "Using default directory ${OUTDIR} for output"
else
	OUTDIR=$1
	echo "Using passed directory ${OUTDIR} for output"
fi

mkdir -p ${OUTDIR}

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/linux-stable" ]; then
    #Clone only if the repository does not exist.
	echo "CLONING GIT LINUX STABLE VERSION ${KERNEL_VERSION} IN ${OUTDIR}"
	git clone ${KERNEL_REPO} --depth 1 --single-branch --branch ${KERNEL_VERSION}
fi
if [ ! -e ${OUTDIR}/linux-stable/arch/${ARCH}/boot/Image ]; then
    cd linux-stable
    echo "Checking out version ${KERNEL_VERSION}"
    git checkout ${KERNEL_VERSION}

    # TODO: Add your kernel build steps here

    echo "TODO: Add your kernel build steps here"

    # “deep clean” the kernel build tree - removing the .config file with any existing configurations
    make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} mrproper
    echo "deep clean (done)"

    # Configure for our “virt” arm dev board we will simulate in QEMU
    make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} defconfig
    echo "defconfig (done)"

    # Build a kernel image for booting with QEMU
    make -j4 ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} all
    echo "Build a kernel image for booting with QEMU (done)"

    # Build any kernel modules (i. Skip the modules_install step)
    # make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} modules
    # echo "modules (done)"

    # Build the devicetree
    make ARCH=arm64 CROSS_COMPILE=${CROSS_COMPILE} dtbs
    echo "dtbs (done)"

    echo "TODO: Add your kernel build steps here (done)"

fi

echo "Adding the Image in outdir"

echo "Creating the staging directory for the root filesystem"
cd "$OUTDIR"
if [ -d "${OUTDIR}/rootfs" ]
then
	echo "Deleting rootfs directory at ${OUTDIR}/rootfs and starting over"
    sudo rm  -rf ${OUTDIR}/rootfs
fi

# TODO: Create necessary base directories

mkdir -p "${OUTDIR}/rootfs"
cd "${OUTDIR}/rootfs"
mkdir -p bin dev etc home lib lib64 proc sbin sys tmp usr var
mkdir -p usr/bin usr/lib usr/sbin
mkdir -p var/log

echo "TODO: Create necessary base directories (done)"


cd "$OUTDIR"
if [ ! -d "${OUTDIR}/busybox" ]
then
git clone git://busybox.net/busybox.git
    cd busybox
    git checkout ${BUSYBOX_VERSION}
    # TODO:  Configure busybox
    make distclean
    make defconfig
    echo "# TODO:  Configure busybox (done)"
else
    cd busybox
    make distclean
    make defconfig
fi

# TODO: Make and install busybox
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
# make CONFIG_PREFIX=/path/to/rootdir ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} install
echo "# TODO: Make and install busybox ${OUTDIR} ${ARCH} ${CROSS_COMPILE}"
make CONFIG_PREFIX=${OUTDIR}/rootfs ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} install
echo "# TODO: Make and install busybox (done)"

echo "Library dependencies"
${CROSS_COMPILE}readelf -a bin/busybox | grep "program interpreter"
${CROSS_COMPILE}readelf -a bin/busybox | grep "Shared library"

# TODO: Add library dependencies to rootfs

# TODO: Make device nodes

# TODO: Clean and build the writer utility

# TODO: Copy the finder related scripts and executables to the /home directory
# on the target rootfs

# TODO: Chown the root directory

# TODO: Create initramfs.cpio.gz
