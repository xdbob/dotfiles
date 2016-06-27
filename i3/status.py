# -*- coding: utf-8 -*-

import subprocess

from i3pystatus import Status

status = Status(standalone=True)

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
    format="%a %-d %b %X",)

# Affiche la charge du processeur
status.register("load")

# Affiche la taille de /home
# Format:
# 42/128G [86G]
# status.register("disk",
#    path="/home/",
#    format="{used}/{total}G [{avail}G]",)

# Affiche le volume
status.register("pulseaudio",
    format="♪{volume}",)

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via dbus) if the percentage
# goes below 5 percent while discharging. The block will also color RED.
status.register("battery",
    format="{status}/{consumption:.2f}W {percentage:.2f}% {remaining:%E%hh:%Mm}",
    alert=True,
    battery_ident="BAT1",
    alert_percentage=5,
    status={
        "DIS": "↓",
        "CHR": "↑",
        "FULL": "=",
    },)

# Show if DHCPD is running
status.register("runwatch",
    name="DHCP",
    path="/var/run/dhcpcd*.pid",)


# Has all the options of the normal network and adds some wireless specific things
# like quality and network names.
#
# Note: requires both netifaces-py3 and basiciw
status.register("network",
    interface="wlp1s0",
    format_up="{essid} {quality:03.0f}%",)

status.run()
