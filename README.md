# OoH: Out of Hypervisor

OoH is a new virtualization research axis advocating the exposure of individually hypervisor-oriented hardware virtualization features to the guest OS so that its processes can also benefit from those features. OoH aims to have processor vendors rethink the logic of virtualization features and incorporate their categorization and exposure to VMs from their conception and design. For existing features, the OoH
logic is to try exposing them using both software and hardware approaches. Regarding software methods, OoH designers should leverage hypercalls and event channel mechanisms to communicate with the hypervisor that remains the root component; provide the guest with libraries to facilitate the usage of the exposed feature; implement kernel modules to avoid guest OS modification and preserve the privilege of the kernel on multiplexing the exposed feature. Concerning the hardware approach, OoH designers can take advantage of VMCS shadowing, originally included for nested virtualization, to reduce the hypervisor intervention. Finally, and only when significantly improving performances, hardware changes can be considered to even more remove the hypervisor in the guest execution path. With the latter option, security considerations must be taken into account to keep ensuring isolation between VMs and vis-à-vis the hypervisor.

OoH can be implemented for both unprivileged and privileged VMs (respectively, dom0 and domU in Xen).

## OoH in domO: PRL
PRL is the OoH implementation of PML for working set size estimation of VMs.
It is published at [VEE'21](https://dl.acm.org/doi/pdf/10.1145/3453933.3454018) ([slides](https://www.youtube.com/watch?v=nKFJtmjo_fU)).
Some artifacts are available [here](prl).


## OoH in domU

### OoH for PML
This is the OoH implementation of PML in domU for dirty page tracking applied to process checkpointing (with CRIU) and concurrent garbage collection (with Boehm GC).
It is published at [SC'22](OoH-PML/ooh.pdf) ([slides](OoH-PML/prez.pdf)).
The code open-sourced [here](OoH-PML).

### OoH for SPP
This is the OoH implementation of SPP in domU for efficient write buffer overflows mitigation in cloud user applications.
Sources are available [here](OoH-SPP).