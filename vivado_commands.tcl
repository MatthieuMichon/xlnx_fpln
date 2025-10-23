# This script is intended to be called from the Vivado TCL interpreter

package require Vivado

proc write_device_list {} {

    # Focus on general-purpose devices
    set parts [get_parts -filter {DEVICE =~ "xc*" && SPEED == "-1" && MIN_OPERATING_TEMPERATURE == "0"}]
    set devices [lsort -unique [get_property DEVICE ${parts}]]

    set fhandle [open ../devices.txt w]
    foreach dev ${devices} { puts ${fhandle} ${dev} }
    close ${fhandle}

}

proc build_part { part } {

    set device [lindex [get_parts -filter "DEVICE =~ ${part}"] 0]
    create_project -part ${device} -in_memory
    report_property [get_parts ${device}] -file part_properties.txt
    read_verilog -sv [glob ../*.sv]
    set top [lindex [find_top] 0]
    if {[catch {synth_design -top ${top} -debug_log -verbose} err_msg]} {
        set fhandle [open ./synth_error.txt w]
        puts ${fhandle} ${err_msg}
        close ${fhandle}
        # do not stop on license error
        return -code ok
    }
    opt_design -debug_log -verbose
    place_design -debug_log -timing_summary -verbose
    route_design -debug_log -tns_cleanup -verbose

    report_clock_utilization -file clock_utilization.txt
    report_io -file io.txt
    report_operating_conditions -file operating_conditions.txt
    report_power -file power.txt
    report_ram_utilization -file ram_utilization.txt
    report_utilization -file utilization.txt

    write_checkpoint -force project.dcp

}

if {[llength ${argv}] < 1} {
    return -code error "ERROR: missing argument"
} else {
    set task [lindex ${argv} 0]
}

switch ${task} {
    "write_device_list" {
        ::write_device_list
    }
    "build_part" {
        set part [lindex ${argv} 1]
        ::build_part ${part}
    }
}
