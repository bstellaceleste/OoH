/*
 * Automatically generated by /home/stella/PML-Xen10/tools/libxc/../../xen/tools/gen-cpuid.py - Do not edit!
 * Source data: /home/stella/PML-Xen10/tools/libxc/../../xen/include/public/arch-x86/cpufeatureset.h
 */
#ifndef __XEN_X86__FEATURESET_DATA__
#define __XEN_X86__FEATURESET_DATA__

#define FEATURESET_NR_ENTRIES 10

#define CPUID_COMMON_1D_FEATURES 0x0183f3ffU

#define INIT_KNOWN_FEATURES { \
    0xbfebfbffU, \
    0xfffef3ffU, \
    0xee500800U, \
    0x2469bfffU, \
    0x0000000fU, \
    0xfdbfffffU, \
    0x0040401fU, \
    0x00000500U, \
    0x00000001U, \
    0x0000000cU, \
}

#define INIT_SPECIAL_FEATURES { \
    0x10000200U, \
    0x88200000U, \
    0x00000000U, \
    0x00000002U, \
    0x00000000U, \
    0x00002040U, \
    0x00000010U, \
    0x00000000U, \
    0x00000000U, \
    0x00000000U, \
}

#define INIT_PV_FEATURES { \
    0x1fc9cbf5U, \
    0xf6f83203U, \
    0xe2500800U, \
    0x042109e3U, \
    0x00000007U, \
    0xfdaf0b39U, \
    0x00404003U, \
    0x00000000U, \
    0x00000001U, \
    0x0000000cU, \
}

#define INIT_HVM_SHADOW_FEATURES { \
    0x1fcbfbffU, \
    0xf7f83223U, \
    0xea500800U, \
    0x042189f7U, \
    0x0000000fU, \
    0xfdbf4bbbU, \
    0x00404007U, \
    0x00000000U, \
    0x00000001U, \
    0x0000000cU, \
}

#define INIT_HVM_HAP_FEATURES { \
    0x1fcbfbffU, \
    0xf7fa3223U, \
    0xee500800U, \
    0x042189f7U, \
    0x0000000fU, \
    0xfdbf4fbbU, \
    0x0040400fU, \
    0x00000000U, \
    0x00000001U, \
    0x0000000cU, \
}

#define NR_DEEP_DEPS 19U

#define INIT_DEEP_FEATURES { \
    0x07800259U, \
    0x140a0201U, \
    0xa0000000U, \
    0x00000000U, \
    0x00000000U, \
    0x00010020U, \
    0x00000000U, \
    0x00000000U, \
    0x00000000U, \
    0x00000000U, \
}

#define INIT_DEEP_DEPS { \
    { 0x0U, /* FPU */ { \
        0x00800000U, \
        0x00000000U, \
        0xc0400000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x3U, /* PSE */ { \
        0x00020000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x4U, /* TSC */ { \
        0x00000000U, \
        0x01000000U, \
        0x08000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000002U, \
        0x00000000U, \
        0x00000100U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x6U, /* PAE */ { \
        0x00000000U, \
        0x00022000U, \
        0x24100000U, \
        0x00000001U, \
        0x00000000U, \
        0x00000400U, \
        0x00000008U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x9U, /* APIC */ { \
        0x00000000U, \
        0x01200000U, \
        0x00000000U, \
        0x00000008U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x17U, /* MMX */ { \
        0x00000000U, \
        0x00000000U, \
        0xc0400000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x18U, /* FXSR */ { \
        0x06000000U, \
        0x021a2201U, \
        0x26000000U, \
        0x000000c1U, \
        0x00000000U, \
        0x20000400U, \
        0x00000008U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x19U, /* SSE */ { \
        0x04000000U, \
        0x021a2201U, \
        0x24000000U, \
        0x000000c1U, \
        0x00000000U, \
        0x20000400U, \
        0x00000008U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x1aU, /* SSE2 */ { \
        0x00000000U, \
        0x00022000U, \
        0x24000000U, \
        0x00000001U, \
        0x00000000U, \
        0x00000400U, \
        0x00000008U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x20U, /* SSE3 */ { \
        0x00000000U, \
        0x00180000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x29U, /* SSSE3 */ { \
        0x00000000U, \
        0x00180000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x31U, /* PCID */ { \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000400U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x33U, /* SSE4_1 */ { \
        0x00000000U, \
        0x00100000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x3aU, /* XSAVE */ { \
        0x00000000U, \
        0x30001000U, \
        0x00000000U, \
        0x00018800U, \
        0x0000000fU, \
        0xdc234020U, \
        0x0000400aU, \
        0x00000000U, \
        0x00000000U, \
        0x0000000cU, \
    }, }, \
    { 0x3cU, /* AVX */ { \
        0x00000000U, \
        0x20001000U, \
        0x00000000U, \
        0x00010800U, \
        0x00000000U, \
        0xdc230020U, \
        0x00004002U, \
        0x00000000U, \
        0x00000000U, \
        0x0000000cU, \
    }, }, \
    { 0x5dU, /* LM */ { \
        0x00000000U, \
        0x00022000U, \
        0x04000000U, \
        0x00000001U, \
        0x00000000U, \
        0x00000400U, \
        0x00000008U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0x5fU, /* 3DNOW */ { \
        0x00000000U, \
        0x00000000U, \
        0x40000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
    }, }, \
    { 0xa5U, /* AVX2 */ { \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0xdc230000U, \
        0x00004002U, \
        0x00000000U, \
        0x00000000U, \
        0x0000000cU, \
    }, }, \
    { 0xb0U, /* AVX512F */ { \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0x00000000U, \
        0xdc220000U, \
        0x00004002U, \
        0x00000000U, \
        0x00000000U, \
        0x0000000cU, \
    }, }, \
}

#define CPUID_BITFIELD_0 \
    bool fpu:1, vme:1, de:1, pse:1, tsc:1, msr:1, pae:1, mce:1, cx8:1, :1, :1, sep:1, mtrr:1, pge:1, mca:1, cmov:1, pat:1, pse36:1, :1, clflush:1, :1, ds:1, acpi:1, mmx:1, fxsr:1, sse:1, sse2:1, ss:1, htt:1, tm1:1, :1, pbe:1

#define CPUID_BITFIELD_1 \
    bool sse3:1, pclmulqdq:1, dtes64:1, monitor:1, dscpl:1, vmx:1, smx:1, eist:1, tm2:1, ssse3:1, :1, :1, fma:1, cx16:1, xtpr:1, pdcm:1, :1, pcid:1, dca:1, sse4_1:1, sse4_2:1, x2apic:1, movbe:1, popcnt:1, tsc_deadline:1, aesni:1, xsave:1, :1, avx:1, f16c:1, rdrand:1, hypervisor:1

#define CPUID_BITFIELD_2 \
    bool :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, syscall:1, :1, :1, :1, :1, :1, :1, :1, :1, nx:1, :1, mmxext:1, :1, :1, ffxsr:1, page1gb:1, rdtscp:1, :1, lm:1, _3dnowext:1, _3dnow:1

#define CPUID_BITFIELD_3 \
    bool lahf_lm:1, cmp_legacy:1, svm:1, extapic:1, cr8_legacy:1, abm:1, sse4a:1, misalignsse:1, _3dnowprefetch:1, osvw:1, ibs:1, xop:1, skinit:1, wdt:1, :1, lwp:1, fma4:1, :1, :1, nodeid_msr:1, :1, tbm:1, topoext:1, :1, :1, :1, dbext:1, :1, :1, monitorx:1, :1, :1

#define CPUID_BITFIELD_4 \
    bool xsaveopt:1, xsavec:1, xgetbv1:1, xsaves:1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1

#define CPUID_BITFIELD_5 \
    bool fsgsbase:1, tsc_adjust:1, sgx:1, bmi1:1, hle:1, avx2:1, fdp_excp_only:1, smep:1, bmi2:1, erms:1, invpcid:1, rtm:1, pqm:1, no_fpu_sel:1, mpx:1, pqe:1, avx512f:1, avx512dq:1, rdseed:1, adx:1, smap:1, avx512ifma:1, :1, clflushopt:1, clwb:1, :1, avx512pf:1, avx512er:1, avx512cd:1, sha:1, avx512bw:1, avx512vl:1

#define CPUID_BITFIELD_6 \
    bool prefetchwt1:1, avx512vbmi:1, umip:1, pku:1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, avx512_vpopcntdq:1, :1, :1, :1, :1, :1, :1, :1, rdpid:1, :1, :1, :1, :1, :1, :1, :1, :1, :1

#define CPUID_BITFIELD_7 \
    bool :1, :1, :1, :1, :1, :1, :1, :1, itsc:1, :1, efro:1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1

#define CPUID_BITFIELD_8 \
    bool clzero:1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1

#define CPUID_BITFIELD_9 \
    bool :1, :1, avx512_4vnniw:1, avx512_4fmaps:1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1, :1


#endif /* __XEN_X86__FEATURESET_DATA__ */
