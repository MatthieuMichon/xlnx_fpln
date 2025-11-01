> [!NOTE]
> This repository is featured in [a discussion](https://adaptivesupport.amd.com/s/question/0D5Pd00000ynGcUKAU/vivado-20251-reportclockutilization-on-xcku3p-returns-wrong-numbers) on the Xilinx community forum regarding [SVD devices](/docs/svd-devices.md).

Hi, having even an approximate idea of the internal FPGA device layout helps especially with designs where latency is a figure of merit. In such instances, design-space exploration can be greatly sped up by having early information on the internal layout of the target FPGA device or family. This purpose of this repository is to provide such information for Xilinx FPGAs.

# Quick Start

> [!NOTE]
> The following assumes that the shell environment is set up correctly.

The [root makefile](./Makefile) default target generates a list of all the targeted FPGA devices supported by the installed version of Vivado. By default, a minimal viable design will be generated for all these devices and an *Enterprise* license is required for generating the complete assortment of files for all devices.

```shell
make
# make -j 16 (assuming available memory is plentiful)
```

As of late-2025, Vivado lacks support for exporting a bitmap image of the floorplan (not holding my breath on this one), requiring manual intervention for inspecting the floorplan -- i.e opening the Vivado GUI and selecting the floorplan view.

```shell
vivado build_$PART/project.dcp

# Consider using the Floorplanning window layout (drop-down menu near the upper-right corner)
```

As mentioned earlier, the build script does store useful information in the following files:

| File                                   | Description                       |
| -------------------------------------- | --------------------------------- |
| `devices.txt`                          | List of all the supported devices |
| `build_$PART/clock_utilization.txt`    | Available clock resources         |
| `build_$PART/io.txt`                   | Package pin table                 |
| `build_$PART/operating_conditions.txt` | Default operating conditions      |
| `build_$PART/part_properties.txt`      | Device properties                 |
| `build_$PART/power.txt`                | Static power consumption          |
| `build_$PART/ram_utilization.txt`      | Available BRAM / LUTRAM           |
| `build_$PART/utilization.txt`          | Available logic resources         |

# Theory of Operation

The build process goes through two stages:
- Generating a list of all the supported devices and stored in `devices.txt`.
- For each device from this list, build a minimal viable design using the module described in the `top_xlnx_fpga.sv` file.
