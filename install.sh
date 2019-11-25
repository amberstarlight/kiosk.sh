#!/usr/bin/env bash

# Declare variables
autostart="${HOME}/.config/lxsession/LXDE-pi/autostart"
cron_file="cron_jobs"

# Print out some cool-looking text :)
clear
echo "888      d8b                   888                  888      "
echo "888      Y8P                   888                  888      "
echo "888                            888                  888      "
echo "888  888 888  .d88b.  .d8888b  888  888    .d8888b  88888b.  "
echo "888 .88P 888 d88\"\"88b 88K      888 .88P    88K      888 \"88b "
echo "888888K  888 888  888 \"Y8888b. 888888K     \"Y8888b. 888  888 "
echo "888 \"88b 888 Y88..88P      X88 888 \"88b d8b     X88 888  888 "
echo "888  888 888  \"Y88P\"   88888P' 888  888 Y8P 88888P' 888  888 "
echo
echo -e "  kiosk.sh - turn Raspberry Pi clients into display kiosks.\n"

# Install unclutter
echo -e "Checking dpkg...\n"
if ! dpkg -l unclutter >/dev/null; then
	echo "Installing required packages..."
	sudo apt update -q -y
	sudo apt upgrade -q -y
	sudo apt install unclutter
	# Clean up after ourselves
	sudo apt autoremove -y
	echo "Done!"
else
	echo -e "Required packages already installed!\n"
fi

# Disable screen blanking
if ! [[ -f ${autostart} ]]; then
	echo "No autostart file, creating..."
	touch ${autostart}
	echo "Done!"
fi

if grep -q 'Kiosk Mode' ${autostart}; then
	echo "Screen blanking already disabled!"
else
	echo "Disabling screen blanking..."
	cp autostart ${autostart}
	echo "Done!"
fi
echo

# Set up cron jobs
if crontab -l | grep -q 'Kiosk Mode'; then
	echo -e "Cron jobs already exist!\n"
else
	echo "Creating cron jobs..."
	crontab -l -u ${USER} | cat - ${cron_file} | crontab -u ${USER} -
	echo -e "Done!"
fi

# Copy script
echo "Updating kiosk script..."

# Ensure scripts are executable
if ! [[ -x kiosk.sh ]]; then
	echo "kiosk.sh not executable, updating..."
	chmod +x kiosk.sh
	echo "Execute permission set!"
fi

cp kiosk.sh ${HOME}
echo -e "Done!\n"

# Enable systemd Service
if [[ -f /lib/systemd/system/kiosk.service ]]; then
	echo "Kiosk service already exists, restarting..."
	sudo systemctl stop kiosk
	sudo systemctl start kiosk
	echo -e "Done!\n"
else
	echo "Creating systemd service for kiosk mode..."
	chmod 664 kiosk.service
	sudo cp kiosk.service /lib/systemd/system
	sudo systemctl daemon-reload
	sudo systemctl enable kiosk
	echo "Starting kiosk mode..."
	sudo systemctl start kiosk
	echo -e "Done!\n"
fi

echo "Install finished."
exit 0
