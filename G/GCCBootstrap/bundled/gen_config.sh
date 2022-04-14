#!/bin/bash

set -euo pipefail

# Start wtih things that are always true
cat <<-EOF
CT_CONFIG_VERSION=4

# Always build GCC v9.X
CT_GCC_V_9=y

CT_BUILD="${MACHTYPE}"
CT_PREFIX_DIR="${prefix}"
CT_PREFIX_DIR_RO=n
CT_RM_RF_PREFIX_DIR=n

# Don't download any tarballs; we should have taken care of that already
CT_FORBID_DOWNLOAD=y
CT_LOCAL_TARBALLS_DIR="${WORKSPACE}/srcdir"

# We always want to build g++
CT_CC_LANG_CXX=y
EOF

# Handle OS stuff
case "${bb_target}" in
    *linux*)
        cat <<-EOF
# We're building against linux, and always use an older kernel
# version so that we are maximally compatible.
CT_KERNEL_LINUX=y
CT_LINUX_V_4_1=y

# We don't like the 'unknown' for Linux
CT_OMIT_TARGET_VENDOR=y
CT_TARGET_VENDOR=
EOF
        ;;
    *)
        echo "Unhandled OS '${bb_target}'" >&2
        exit 1
        ;;
esac

# Handle arch stuff
case "${bb_target}" in
    arm*)
        echo "CT_ARCH_ARM=y"
        ;;
    aarch64*)
        echo "CT_ARCH_ARM=y"
        echo "CT_ARCH_64=y"
        ;;
    i686*)
        echo "CT_ARCH_X86=y"
        echo "CT_ARCH_ARCH=\"pentium4\""
        ;;
    x86_64*)
        echo "CT_ARCH_X86=y"
        echo "CT_ARCH_64=y"
        ;;
    *)
        echo "ERROR: Unhandled arch '${bb_target}'" >&2
        exit 1
esac

# Handle libc stuff
case "${bb_target}" in
    *gnu*)
        echo "CT_GLIBC_V_2_19=y"
        ;;
    *musl*)
        echo "CT_EXPERIMENTAL=y"
        echo "CT_LIBC_MUSL=y"
        echo "CT_MUSL_v_1_2_2=y"
        ;;
    *)
        echo "ERROR: Unhandled libc '${bb_target}'" >&2
        exit 1
        ;;
esac
