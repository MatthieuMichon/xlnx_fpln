BUILD_DIR_PREFIX = ./build
DEVICE_LIST_FILE = ./devices.txt

.PHONY: all clean

all: $(DEVICE_LIST_FILE)
	cat $< | while read DEVICE; do \
		mkdir -p $(BUILD_DIR_PREFIX)_$${DEVICE}; \
		cd $(BUILD_DIR_PREFIX)_$${DEVICE} && vivado -mode batch -source ../vivado_commands.tcl -tclargs build_part $${DEVICE}; \
		status=$$?; \
		if [ $${status} -ne 0 ]; then \
			echo "ERROR: Build failed for device $${DEVICE}"; \
			exit 1; \
		fi; \
		cd ..; \
	done

$(DEVICE_LIST_FILE):
	mkdir -p build_device_list
	cd build_device_list && vivado -mode batch -source ../vivado_commands.tcl -tclargs write_device_list

clean:
	$(RM) $(DEVICE_LIST_FILE)
	$(RM) -r $(BUILD_DIR_PREFIX)_*
