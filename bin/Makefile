.PHONY: all udev

udev: 98-monitor-hotplug.rules
	mkdir -p /etc/udev/rules.d 2> /dev/null
	cp 98-monitor-hotplug.rules /etc/udev/rules.d/98-monitor-hotplug.rules
	udevadm control --reload

all:
	python3 -m pip install --user -U -r requirements.txt

	mkdir -p $(HOME)/.local/share/applications 2> /dev/null
	cp magnet-clipboard.desktop $(HOME)/.local/share/applications

	@echo "\nTo install udev rules run make udev as root."
