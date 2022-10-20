#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# disk usage using awk

# rewrote this and super simplified it just using 'lsblk'
#     WOW - lsblk has a sort option
# eeked out a little more bar length
#     easily adjustable columns

lsblk -nx "mountpoint" -o  "name,fssize,fsused,fsavail,mountpoint" | disk.awk

power.sh
