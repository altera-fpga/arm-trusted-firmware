#
# Copyright (c) 2019-2020, ARM Limited and Contributors. All rights reserved.
# Copyright (c) 2019-2023, Intel Corporation. All rights reserved.
# Copyright (c) 2024-2025, Altera Corporation. All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

# 1: build SiP V3 SMC + multi-client mailbox; 0: classic mailbox only (Zephyr).
SOCFPGA_SIP_SVC_V3		?=	1
$(eval $(call assert_boolean,SOCFPGA_SIP_SVC_V3))
$(eval $(call add_define,SOCFPGA_SIP_SVC_V3))

include lib/xlat_tables_v2/xlat_tables.mk
include lib/libfdt/libfdt.mk
PLAT_INCLUDES		:=	\
			-Iplat/altera/soc/agilex27/include/		\
			-Iplat/altera/soc/common/drivers/		\
			-Iplat/altera/soc/common/lib/sha/		\
			-Iplat/altera/soc/common/lib/utils/		\
			-Iplat/altera/soc/common/include        \
			-Iplat/altera/soc/common/drivers/mailbox

# GIC-600 configuration
GICV3_SUPPORT_GIC600	:=	1
# Newer Simics Agilex27 models report GICD_PIDR2.ArchRev = 4 (GICv4), and
# gicv3_main.c only accepts that when GIC_ENABLE_V4_EXTN is enabled.
GIC_ENABLE_V4_EXTN	:=	1

# Include GICv3 driver files
include drivers/arm/gic/v3/gicv3.mk
AGX72_GICv3_SOURCES	:=	\
			${GICV3_SOURCES}				\
			plat/common/plat_gicv3.c

PLAT_BL_COMMON_SOURCES	:=	\
			${AGX72_GICv3_SOURCES}				\
			common/fdt_wrappers.c				\
			drivers/cadence/combo_phy/cdns_combo_phy.c	\
			drivers/cadence/emmc/cdns_sdmmc.c	\
			drivers/cadence/nand/cdns_nand.c	\
			drivers/delay_timer/delay_timer.c		\
			drivers/delay_timer/generic_delay_timer.c	\
			drivers/ti/uart/aarch64/16550_console.S		\
			plat/altera/soc/common/aarch64/platform_common.c	\
			plat/altera/soc/common/aarch64/plat_helpers.S	\
			plat/altera/soc/common/drivers/ccu/ncore_ccu.c	\
			plat/altera/soc/common/drivers/combophy/combophy.c			\
			plat/altera/soc/common/drivers/config_dma/socfpga_config_dma.c \
			plat/altera/soc/common/drivers/sdmmc/sdmmc.c			\
			plat/altera/soc/common/drivers/ddr/ddr.c			\
			plat/altera/soc/common/drivers/mailbox/socfpga_mailbox.c		\
			plat/altera/soc/common/drivers/mailbox/socfpga_mailbox_client.c		\
			plat/altera/soc/common/drivers/mailbox/socfpga_mailbox_core.c		\
			plat/altera/soc/common/drivers/mailbox/mcsr/socfpga_mcsr_mailbox.c	\
			plat/altera/soc/common/drivers/mailbox/mcsr/socfpga_mcsr_s2c.c		\
			plat/altera/soc/common/drivers/mailbox/mcsr/socfpga_mcsr_c2s.c		\
			plat/altera/soc/common/drivers/nand/nand.c			\
			plat/altera/soc/common/drivers/xspi/cadence_xspi.c		\
			plat/altera/soc/common/lib/sha/sha.c				\
			plat/altera/soc/common/socfpga_delay_timer.c	\
			plat/altera/soc/common/socfpga_dt.c

BL2_SOURCES		+=	\
		common/desc_image_load.c				\
		lib/xlat_tables_v2/aarch64/enable_mmu.S	\
		lib/xlat_tables_v2/xlat_tables_context.c \
		lib/xlat_tables_v2/xlat_tables_core.c \
		lib/xlat_tables_v2/aarch64/xlat_tables_arch.c \
		lib/xlat_tables_v2/xlat_tables_utils.c \
		drivers/mmc/mmc.c					\
		drivers/intel/soc/stratix10/io/s10_memmap_qspi.c	\
		drivers/io/io_storage.c					\
		drivers/io/io_block.c					\
		drivers/io/io_fip.c					\
		drivers/io/io_mtd.c					\
		drivers/partition/partition.c				\
		drivers/partition/gpt.c					\
		drivers/synopsys/emmc/dw_mmc.c				\
		lib/cpus/aarch64/cortex_a520.S				\
		lib/cpus/aarch64/cortex_a720.S				\
		plat/altera/soc/agilex27/soc/agilex27_clock_manager.c	\
		plat/altera/soc/agilex27/soc/agilex27_memory_controller.c	\
		plat/altera/soc/agilex27/soc/agilex27_mmc.c		\
		plat/altera/soc/agilex27/soc/agilex27_pinmux.c		\
		plat/altera/soc/agilex27/soc/agilex27_power_manager.c	\
		plat/altera/soc/agilex27/soc/agilex27_ddr.c		\
		plat/altera/soc/agilex27/soc/agilex27_iossm_mailbox.c	\
		plat/altera/soc/common/bl2_plat_mem_params_desc.c	\
		plat/altera/soc/common/socfpga_image_load.c		\
		plat/altera/soc/common/socfpga_ros.c			\
		plat/altera/soc/common/socfpga_storage.c			\
		plat/altera/soc/common/socfpga_vab.c			\
		plat/altera/soc/common/soc/socfpga_emac.c		\
		plat/altera/soc/common/soc/socfpga_firewall.c		\
		plat/altera/soc/common/soc/socfpga_handoff.c		\
		plat/altera/soc/common/soc/socfpga_reset_manager.c	\
		plat/altera/soc/common/drivers/qspi/cadence_qspi.c	\
		plat/altera/soc/agilex27/bl2_plat_setup.c			\
		plat/altera/soc/common/drivers/wdt/watchdog.c

include lib/zlib/zlib.mk
PLAT_INCLUDES	+=	-Ilib/zlib
BL2_SOURCES	+=	$(ZLIB_SOURCES)

BL31_SOURCES	+=	\
		drivers/arm/cci/cci.c					\
		${XLAT_TABLES_LIB_SRCS}						\
		lib/cpus/aarch64/aem_generic.S				\
		lib/cpus/aarch64/cortex_a520.S				\
		lib/cpus/aarch64/cortex_a720.S				\
		plat/common/plat_psci_common.c				\
		plat/altera/soc/agilex27/bl31_plat_setup.c		\
		plat/altera/soc/agilex27/soc/agilex27_cache.S		\
		plat/altera/soc/agilex27/soc/agilex27_clock_manager.c	\
		plat/altera/soc/agilex27/soc/agilex27_power_manager.c	\
		plat/altera/soc/common/socfpga_psci.c			\
		plat/altera/soc/common/socfpga_sip_svc.c			\
		plat/altera/soc/common/socfpga_topology.c		\
		plat/altera/soc/common/sip/socfpga_sip_ecc.c		\
		plat/altera/soc/common/sip/socfpga_sip_fcs.c		\
		plat/altera/soc/common/soc/socfpga_system_manager.c	\
		plat/altera/soc/common/lib/utils/alignment_utils.c \
		plat/altera/soc/common/drivers/mailbox/socfpga_mailbox_client.c	\
		plat/altera/soc/common/soc/socfpga_reset_manager.c

# Configs for A76 and A55
HW_ASSISTED_COHERENCY := 1
USE_COHERENT_MEM := 0
CTX_INCLUDE_AARCH32_REGS := 0
#ERRATA_A55_1530923 := 1
ARM_ARCH_MAJOR := 9
ERRATA_A720_2792132	:=	1
ERRATA_A720_2844092	:=	1
ERRATA_A720_2926083	:=	1
ERRATA_A720_2940794	:=	1
WORKAROUND_CVE_2022_23960	:= 0


# Don't have the Linux kernel as a BL33 image by default
ARM_LINUX_KERNEL_AS_BL33	:=	0
$(eval $(call assert_boolean,ARM_LINUX_KERNEL_AS_BL33))
$(eval $(call add_define,ARM_LINUX_KERNEL_AS_BL33))
$(eval $(call add_define,ARM_PRELOADED_DTB_BASE))

# Configs for Boot Source
SOCFPGA_BOOT_SOURCE_SDMMC		?=	0
SOCFPGA_BOOT_SOURCE_QSPI		?=	0
SOCFPGA_BOOT_SOURCE_NAND		?=	0
SOCFPGA_BOOT_SOURCE_OSPI		?=	0

$(eval $(call assert_booleans,\
	$(sort \
		SOCFPGA_BOOT_SOURCE_SDMMC \
		SOCFPGA_BOOT_SOURCE_QSPI \
		SOCFPGA_BOOT_SOURCE_NAND \
		SOCFPGA_BOOT_SOURCE_OSPI \
)))
$(eval $(call add_defines,\
	$(sort \
		SOCFPGA_BOOT_SOURCE_SDMMC \
		SOCFPGA_BOOT_SOURCE_QSPI \
		SOCFPGA_BOOT_SOURCE_NAND \
		SOCFPGA_BOOT_SOURCE_OSPI \
)))

# Configs for VAB Authentication
SOCFPGA_SECURE_VAB_AUTH  := 	0
$(eval $(call assert_boolean,SOCFPGA_SECURE_VAB_AUTH))
$(eval $(call add_define,SOCFPGA_SECURE_VAB_AUTH))

# Simics model bypass: skip incomplete km-hps-sdmmc combo-PHY / card-detect.
# Default 0 keeps full silicon behaviour for production. Set to 1 for Simics.
# Does NOT skip FIP load — front-door SD boot still calls load_auth_image().
AGILEX27_SIMICS_BYPASS		?=	0
$(eval $(call assert_boolean,AGILEX27_SIMICS_BYPASS))
$(eval $(call add_define,AGILEX27_SIMICS_BYPASS))

PROGRAMMABLE_RESET_ADDRESS	:= 0
RESET_TO_BL2			:= 1
BL2_INV_DCACHE			:= 0

#To get the TF-A version via SMC calls
DEFINES += -DVERSION_MAJOR=${VERSION_MAJOR}
DEFINES += -DVERSION_MINOR=${VERSION_MINOR}
DEFINES += -DVERSION_PATCH=${VERSION_PATCH}
