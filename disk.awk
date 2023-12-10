#!/usr/bin/awk -f
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# 2023-04-22 rewrote simplifying
# 2023-04-23 exponent zero glitch fixed
# 2023-04-29 added read-only red
# 2023-08-12 changed dot
# ==============================================================================
BEGIN {
   RED="\033[0;1;31m"
   MAG="\033[0;1;35m"
   nrm="\033[0m"

   w1=35                                  # first column width <<< adjust this
   w2=90-w1
   w3=w1+w2+27

   if(q==0)
   {
      for(i=0;i<w3;i++)                      # dividers
      {
         d1=d1"-"
         d2=d2"="
      }
                                             # heading
      printf("%s\n%s   "RED"%s"nrm" %s\n%s\n",d2,"Disk Usage","read-only","flash drive failure",d1)
   }
   printf("%-"w1"s%7s%7s%7s%5s\n","DRIVE","SIZE","USED","AVAIL","%USE")
 }
# ==============================================================================
{
   if(NF>1)
   {
      sub(/\/.*\//,"",$5)                 # remove leading directory
      switch($5)
      {
         case "efi" :                     # don't print items
            break
         default :
            o=""                          # check ro/rw status
            cmd="findmnt -no vfs-options \"/dev/"$1"\" | lsdrv.awk -v q=0"
            cmd | getline o
            close(cmd)
            printf("%s",o)
            p=$3/$2                       # percentage fraction
            printf("%s",$5)               # first column
            l=length($5)
            for(i=l;i<w1;i++)
               printf("·")
            for(i=2;i<=4;i++)             # sizes in powers of 3
               fx_exp($i)
            printf(" %3d%% ",int(p*100))  # percentage
            a=int(p*w2)                   # bargraph
            b=w2-a
            for(i=0;i<a;i++)
               printf("|")
            for(i=0;i<b;i++)
               printf("·")
            printf(nrm"\n")                   # finish line
      }
   }
}
# ==============================================================================
END {
   if(q==0)
      printf("%s\n",d2)
}
# ==============================================================================
# functions
# ------------------------------------------------------------------------------
function fx_exp(n)
{
   if(n)                                     # log doesn't like zero
   {
      e=int(int(log(n)/log(10))/3)*3
      n=n/10^e
   }
   else
      e=0
   s=sprintf("%4.1f",n)
   switch(e)
   {
      case "0" :
         s=s" "
         break
      case "3" :
         s=s"K"
         break
      case "6" :
         s=s"M"
         break
      case "9" :
         s=s"G"
         break
      case "12" :
         s=s"T"
   }
   printf(" %6s",s)
}
# ==============================================================================
