# Define the build directory
BUILD_DIR = build

# Define the prefix for the pk3 files
PK3_PREFIX = GemServ_

# Define the directories to be zipped
DIRS = Maps Main

# Generate the full names of the pk3 files with the prefix
PK3_FILES = $(addprefix $(BUILD_DIR)/$(PK3_PREFIX), $(addsuffix .pk3, $(DIRS)))

# Default target: builds all pk3 files
.PHONY: all
all: $(PK3_FILES)

# Rule to create the build directory if it doesn't exist
$(BUILD_DIR):
	@mkdir -p $@

# Generic rule to create a .pk3 file from a directory
$(BUILD_DIR)/$(PK3_PREFIX)%.pk3: % $(BUILD_DIR)
	@echo "Creating $@ from $<"
	@zip -r $@ $<

# Clean target: removes only the built .pk3 files
.PHONY: clean
clean:
	@echo "Cleaning up built .pk3 files..."
	@if [ -z "$(BUILD_DIR)" ]; then \
		echo "Error: BUILD_DIR is empty. Aborting clean to prevent accidental deletion." ;\
	elif [ "$(BUILD_DIR)" = "." ]; then \
		echo "Error: BUILD_DIR is set to current directory (.). Aborting clean to prevent accidental deletion." ;\
	else \
		rm -f $(PK3_FILES) ;\
		echo "Clean complete." ;\
	fi

.PHONY: help
help:
	@echo "Makefile for creating .pk3 files from project directories with a prefix."
	@echo ""
	@echo "Usage:"
	@echo "  make all     - Builds all .pk3 files (e.g., GemServ_Chars.pk3) into the build directory."
	@echo "  make clean   - Removes only the built .pk3 files from the build directory."
	@echo "  make GemServ_Chars.pk3 - Builds only GemServ_Chars.pk3."
	@echo "  make GemServ_Maps.pk3  - Builds only GemServ_Maps.pk3."
	@echo "  make GemServ_Main.pk3  - Builds only GemServ_Main.pk3."
