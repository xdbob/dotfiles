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

# Affiche l'utilisation du CPU (%)
status.register("cpu_usage")

# Affiche la des infos sur la memoire
status.register("mem",
        format="{used_mem}GiB/{total_mem}GiB|{percent_used_mem}%",
        divisor=1024**3,)

# Show your CPU temperature, if you have a Intel CPU
status.register("temp",
        format="{temp:.0f}°C",)

# Show current keymap and allows to switch by click
status.register("xkblayout",
        layouts=["us", "fr"],)

# Affiche le volume
status.register("pulseaudio",
    format="♪{volume}",)

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via dbus) if the percentage
# goes below 10 percent while discharging. The block will also color RED.
status.register("battery",
    format="{status}/{consumption:.2f}W {percentage:.2f}% {remaining:%E%hh:%Mm}",
    alert=True,
    alert_percentage=10,
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
    interface="ether",
    format_up="{v4cidr}",)

status.register("network",
    interface="wifi",
    format_up="{v4cidr} {essid} {quality}%",)

# Shows disk usage of /home
# Format:
# 42/128G [86G]
status.register("disk",
    path="/home",
    format="{used}/{total}G [{avail}G]",)

status.run()
