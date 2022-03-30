# Artifact-Eval

Out of Hypervisor (OoH) is a new virtualization research axis. Instead of emulating full virtual hardware inside a VM to support a hypervisor, the OoH principle is to individually expose current hypervisor-oriented hardware virtualization features to the guest OS. This way, guest’s processes could also take benefit from those features. We illustrate OoH with Intel PML (Page modification Logging), a feature that allows efficient dirty page tracking to improve VM live migration. Because dirty page tracking is at the heart of many essential tasks including process checkpointing (e.g., CRIU) and concurrent garbage collection (e.g, Boehm GC), OoH exposes PML to accelerate these tasks in the guest. We present two OoH solutions namely Shadow PML (SPML) and
Extended PML (EPML) that we integrated into CRIU and Boehm GC. Evaluation results showed that EPML speeds up CRIU checkpointing by about `13x` and Boehm garbage collection by up to 6× compared to SPML, /proc, and userfaultfd while reducing the impact of monitoring applications by about `16x`.

OoH is implemented using Xen 4.10.0 hypervisor, Linux 4.15.0 guest OS, and BOCHS 2.6.11 Intel x86 emulator (only for EPML, which extends the hardware), Boehm Garbage Collector and CRIU.

This repo provides the tools aand directives to evaluate SPML and EPML implementations.

## Shadow PML (SPML)

