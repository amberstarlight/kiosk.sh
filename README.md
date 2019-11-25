```
888      d8b                   888                  888
888      Y8P                   888                  888
888                            888                  888
888  888 888  .d88b.  .d8888b  888  888    .d8888b  88888b.
888 .88P 888 d88""88b 88K      888 .88P    88K      888 "88b
888888K  888 888  888 "Y8888b. 888888K     "Y8888b. 888  888
888 "88b 888 Y88..88P      X88 888 "88b d8b     X88 888  888
888  888 888  "Y88P"   88888P' 888  888 Y8P 88888P' 888  888
```

A script to turn a Raspberry Pi into a display kiosk.

## Why?
There are many guides on how to turn a Raspberry Pi into a kiosk - but the process isn't simple to deploy if you want to make multiple kiosks. The process involves creating and editing several files, and this has to be repeated perfectly on each client. With kiosk.sh, you can clone the repository, make any configuration changes unique to your requirements, run the install script and reboot your Pi - and you'll have a kiosk.

## Configuration
The script relies on some included files;
- `autostart` contains the xset commands needed to disable screen blanking. It also contains the defaults from the global autostart file, to make sure we start the full desktop environment.

- `cron_jobs` is where you should put any cron jobs that you want to run. The included example will turn the display off during 'closing hours'. Use a service like [crontab.guru](https://crontab.guru/) to make this simpler!

- `kiosk.service` is the [systemd service file](https://www.freedesktop.org/software/systemd/man/systemd.service.html). Here we specify how and when to start our kiosk.

- `kiosk.sh` is the script that is executed by the systemd service. Here is where you should put what you want to run as your kiosk. The included example opens Chromium in kiosk mode.

Once you have made any edits, you can run the install script.

## Installation
Clone this repository and enter the folder;
```
git clone https://github.com/amberstarlight/kiosk.sh.git
cd kiosk.sh
```

Make sure `install.sh` is executable;

```
chmod +x install.sh
```

Then run the install script;

```
./install.sh
```

The script will install unclutter (if not already installed), create the autostart file to disable screen blanking, set up the cron jobs, and create and start the kiosk service! You may wish to reboot the Pi, or log out and log back in at this stage, as the screen blanking will not be disabled until the `autostart` file is loaded.

If you have already run `install.sh`, running it again will update any changes you have made to `kiosk.sh`, and restart the service. This removes the need to restart the Pi after editing the kiosk script.

## Todo
Currently, if you make configuration changes to the cron jobs or autostart file, running `install.sh` again will not update these files. The script should be more specific about what it looks for in these files, and update them - rather than overwriting them or simply appending content to them.

If you have already edited your crontab, the script will overwrite any contents. The script should only add your tasks to the cron table, if they do not already exist.

There is no currently no simple uninstall script.
