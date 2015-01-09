#!/bin/bash

ver="1.1"

./build.sh
sudo cp chronicle /usr/local/bin/chronicle
sudo chown root:wheel /usr/local/bin/chronicle

sudo cp tk.unstac.chronicle.plist /Library/LaunchDaemons/tk.unstac.chronicle.plist
sudo chown root:wheel /Library/LaunchDaemons/tk.unstac.chronicle.plist

sudo pkggen -i tk.unstac.chronicle -v "$ver" --postinstall postinstall files out.pkg
sudo chown administrator:staff out.pkg
mv out.pkg "chronicle-$ver.pkg"
