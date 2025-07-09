# Makefile for elementary-xfce-minios build
# This is a port of build.sh to Makefile format

SHELL := /bin/bash
.ONESHELL:

# Variables
SCRIPT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR := $(SCRIPT_DIR)/build
ELEMENTARY_XFCE := $(BUILD_DIR)/elementary-xfce
MINIOS_ICONS := $(SCRIPT_DIR)/minios-icons

# Default target
all: build

# Function to create symbolic links (used throughout the build)
define lnsvg
	if [ -f $(1) ]; then \
		if [ -f $(2) ]; then \
			rm -f $(2); \
		fi; \
		ln -s $(1) $(2); \
	fi
endef

# Check dependencies
check-deps:
	@if ! command -v git &>/dev/null; then \
		echo "git could not be found"; \
	fi
	@if ! command -v rsync &>/dev/null; then \
		echo "rsync could not be found"; \
	fi

# Clean and clone elementary-xfce
clone: check-deps
	@mkdir -p $(BUILD_DIR)
	@if [ -d $(ELEMENTARY_XFCE) ]; then \
		rm -rf $(ELEMENTARY_XFCE); \
	fi
	cd $(BUILD_DIR)
	git clone --depth 1 -b v0.21 https://github.com/shimmerproject/elementary-xfce.git

# Sync icons
sync-icons: clone
	rsync -a --include='*.svg' --include='*/' --exclude='*' $(MINIOS_ICONS)/ $(ELEMENTARY_XFCE)/

# Configure apps icons
configure-apps: sync-icons
	@for FOLDER in $$(find $(ELEMENTARY_XFCE)/elementary-xfce/apps -type d -regex ".*/[0-9]+$$"); do \
		cd $$FOLDER; \
		if [ -f baobab.svg ]; then \
			$(call lnsvg,baobab.svg,org.gnome.baobab.svg); \
		elif [ -f org.gnome.baobab.svg ]; then \
			$(call lnsvg,org.gnome.baobab.svg,baobab.svg); \
		fi; \
		$(call lnsvg,../../places/$$(basename $$FOLDER)/distributor-logo-minios.svg,org.xfce.panel.applicationsmenu.svg); \
		$(call lnsvg,usb-creator-gtk.svg,minios-installer.svg); \
		$(call lnsvg,menulibre.svg,minios-configurator.svg); \
		$(call lnsvg,accessories-calculator.svg,galculator.svg); \
		$(call lnsvg,internet-mail.svg,emblem-mail.svg); \
		$(call lnsvg,preferences-system-power.svg,laptop-mode-tools.svg); \
		$(call lnsvg,pdfshuffler.svg,com.github.jeromerobert.pdfarranger.svg); \
		$(call lnsvg,pdfshuffler.svg,pdfarranger.svg); \
		$(call lnsvg,pdfshuffler.svg,pdfmod.svg); \
		$(call lnsvg,utilities-terminal.svg,guake.svg); \
		$(call lnsvg,libreoffice-draw.svg,drawio.svg); \
		$(call lnsvg,../../status/$$(basename $$FOLDER)/sync-synchronizing.svg,grsync.svg); \
		$(call lnsvg,../../devices/$$(basename $$FOLDER)/drive-harddisk.svg,gsmartcontrol.svg); \
		$(call lnsvg,utilities-system-monitor.svg,qps.svg); \
		$(call lnsvg,web-browser.svg,falkon.svg); \
		$(call lnsvg,./../actions/$$(basename $$FOLDER)/edit-paste.svg,qlipper.svg); \
		$(call lnsvg,usb-receiver.svg,unetbootin.svg); \
		$(call lnsvg,application-x-firmware.svg,hardinfo.svg); \
		$(call lnsvg,application-x-firmware.svg,lshw-gtk.svg); \
		$(call lnsvg,../../devices/$$(basename $$FOLDER)/fingerprint.svg,org.gtkhash.gtkhash.svg); \
		$(call lnsvg,dialog-password.svg,gpa.svg); \
		$(call lnsvg,../../actions/$$(basename $$FOLDER)/system-lock-screen.svg,keepassxc.svg); \
		$(call lnsvg,../../status/$$(basename $$FOLDER)/security-high.svg,zuluCrypt.svg); \
		$(call lnsvg,org.xfce.ristretto.svg,ristretto.svg); \
		$(call lnsvg,system-file-manager.svg,Thunar.svg); \
		$(call lnsvg,../../devices/$$(basename $$FOLDER)/fingerprint.svg,gtkhash.svg); \
		$(call lnsvg,../../categories$$(basename $$FOLDER)/preferences.system.notifications.svg,xfce4.notifyd.svg); \
		$(call lnsvg,org.xfce.panel.svg,xfce4-panel.svg); \
		$(call lnsvg,preferences-system-power.svg,xfce4-power-manager-settings.svg); \
		$(call lnsvg,org.xfce.screenshooter.svg,applets-screenshooter.svg); \
		$(call lnsvg,session-properties.svg,xfce4-session.svg); \
		$(call lnsvg,../../categories/$$(basename $$FOLDER)/preferences-system-notifications.svg,xfce4-notifyd.svg); \
		$(call lnsvg,preferences-system-windows.svg,xfwm4.svg); \
		$(call lnsvg,preferences-desktop-effects.svg,wmtweaks.svg); \
		$(call lnsvg,org.xfce.workspaces.svg,xfce4-workspaces.svg); \
		$(call lnsvg,org.wireshark.Wireshark.svg,wireshark.svg); \
		$(call lnsvg,org.xfce.panel.whiskermenu.svg,xfce4-whiskermenu.svg); \
		$(call lnsvg,menu-editor.svg,xfce4-menueditor.svg); \
	done

# Configure actions icons
configure-actions: configure-apps
	@for FOLDER in $$(find $(ELEMENTARY_XFCE)/elementary-xfce/actions -type d -regex ".*/[0-9]+$$"); do \
		cd $$FOLDER; \
		$(call lnsvg,view-grid-symbolic.svg,view-list.svg); \
		$(call lnsvg,view-dual-symbolic.svg,view-preview.svg); \
		$(call lnsvg,view-compact-symbolic.svg,view-list-text.svg); \
		$(call lnsvg,view-list-symbolic.svg,view-list-detalis.svg); \
	done

# Configure places icons
configure-places: configure-actions
	@for FOLDER in $$(find $(ELEMENTARY_XFCE)/elementary-xfce/places -type d -regex ".*/[0-9]+$$"); do \
		cd $$FOLDER; \
		$(call lnsvg,distributor-logo-minios.svg,distributor-logo.svg); \
	done

# Configure mimetypes icons
configure-mimetypes: configure-places
	@for SIZE in 16 24 32 48 64 96 128 symbolic; do \
		cd $(ELEMENTARY_XFCE)/elementary-xfce/mimetypes/$$SIZE; \
		if [ -f office-database.svg ]; then \
			ln -s office-database.svg application-x-sb.svg; \
		fi; \
	done

# Create source tarball
create-tarball: configure-mimetypes
	cd $(BUILD_DIR)
	tar --exclude-vcs -zcf elementary-minios_$$(cd $(SCRIPT_DIR) && dpkg-parsechangelog --show-field Version | sed "s/-[^-]*$$//").orig.tar.gz ./elementary-xfce

# Copy debian directory
copy-debian: create-tarball
	cp -R $(SCRIPT_DIR)/debian $(ELEMENTARY_XFCE)/

# Build package
build-package: copy-debian
	cd $(ELEMENTARY_XFCE)
	apt build-dep .
	dpkg-buildpackage -uc -us

# Main build target
build: build-package
	@echo "Build completed! Packages are available in $(BUILD_DIR)/"
	@ls -la $(BUILD_DIR)/*.deb $(BUILD_DIR)/*.tar.gz $(BUILD_DIR)/*.dsc 2>/dev/null || true

# Clean target
clean:
	@if [ -d $(BUILD_DIR) ]; then \
		rm -rf $(BUILD_DIR); \
	fi
	@echo "Build directory cleaned"

# Clean only temporary files, keep packages
clean-temp:
	@if [ -d $(ELEMENTARY_XFCE) ]; then \
		rm -rf $(ELEMENTARY_XFCE); \
	fi
	@rm -f $(BUILD_DIR)/elementary-minios_*.debian.tar.xz
	@rm -f $(BUILD_DIR)/elementary-minios_*.buildinfo
	@rm -f $(BUILD_DIR)/elementary-minios_*.changes
	@echo "Temporary files cleaned, packages preserved"

# Help target
help:
	@echo "Available targets:"
	@echo "  all          - Build the package (default)"
	@echo "  build        - Build the package"
	@echo "  clean        - Clean all build artifacts including packages"
	@echo "  clean-temp   - Clean only temporary files, keep packages"
	@echo "  check-deps   - Check and install dependencies"
	@echo "  clone        - Clone elementary-xfce repository"
	@echo "  sync-icons   - Sync minios icons"
	@echo "  help         - Show this help message"

.PHONY: all build clean clean-temp check-deps clone sync-icons configure-apps configure-actions configure-places configure-mimetypes create-tarball copy-debian build-package help
