BUILD_DIR_PREFIX = ./build
DEVICE_LIST_FILE = ./devices.txt

.PHONY: all devices builds clean

all: devices builds

devices: $(DEVICE_LIST_FILE)

builds: devices
	$(MAKE) $(patsubst %, $(BUILD_DIR_PREFIX)_%, $(shell cat $(DEVICE_LIST_FILE)))

$(DEVICE_LIST_FILE):
	mkdir -p build_device_list
	cd build_device_list && vivado -mode batch -source ../vivado_commands.tcl -tclargs write_device_list

$(BUILD_DIR_PREFIX)_%: $(DEVICE_LIST_FILE)
	mkdir -p $@
	cd $@ && vivado -mode batch -source ../vivado_commands.tcl -tclargs build_part $*

clean:
	$(RM) $(DEVICE_LIST_FILE)
	$(RM) -r $(BUILD_DIR_PREFIX)_*
