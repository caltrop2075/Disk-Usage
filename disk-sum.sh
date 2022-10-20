#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
clear
# source ~/data/global.dat

div="# "
for ((i=2;i<117;i++))
do
   div=$div"-"
done
title-80.sh -t line "external disk usage summary - first level directories"
sleep 1
for drv in $MEDIA/*
do
   echo "$div"
   t=$(lsblk -nbo fssize $(findmnt -no source $drv))
   find $drv -maxdepth 1 -type d -exec du -bs {} \; | sort -k 2 |
   while IFS=$(printf "\t") read s1 s2
   do
      s2=${s2/$drv/}
      printf "%d|%s\n" "$s1" "$s2"
   done | disk-sum.awk -v t=$t -v d=$drv
done
echo "$div"
