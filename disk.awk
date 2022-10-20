#!/usr/bin/awk -f
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# record structure
# 1 name          /dev/sda5
# 2 fssize        218.5G
# 3 fsused        117.6G
# 4 fsavail        89.7G
# 5 mountpoint    /
# ==============================================================================
BEGIN {
   f0=117                              # overall width, 117 optimum
   f1=int(0.30*f0)                     # col 1; f0=117 -> 30% -> f1=35
   f2=6                                # col 2-4
   f3=f0-f1-3*f2-9                     # bar magnitude

   c0="‧"                              # right chr |-|·|‧|

   d1="";d2=""                         # dividers
   for(i=0;i<f0;i++)
   {
      d1=d1"-"
      d2=d2"="
   }

   env=ENVIRON["MEDIA"]"/"               # get $MEDIA envrionment variable
   printf("%s\n%s\n%s\n",d2,"Disk Usage",d1)
   printf("%-"f1"s %"f2"s %"f2"s %"f2"s %s\n","DRIVE","SIZE","USED","AVAIL","%USE")
}
# ==============================================================================
{
   if(NF==5 && !match($5,/\/boot\//))   # output filtering
   {                                   # format drive name
      sub(env,"")                        # remove $MEDIA from drive names
      s=substr($5,1,f1)                # max len name, DVD can be long
      s=s fx_dot(length(s),f1)         # name right
      p=fx_p($2,$3)                    # percent
      a=int(f3*p+0.5)                  # bar
      b=""                             # build bar graph
      for(i=0;i<a;i++)                 # bar left
          b=b"|"
      b=b fx_dot(a,f3)                 # bar right
      printf("%s %"f2"s %"f2"s %"f2"s %3.f%% %s\n",s,$2,$3,$4,int(p*100+0.5),b)
   }
}
# ==============================================================================
END {
   printf("%s\n",d2)
}
# ==============================================================================
# functions
# ------------------------------------------------------------------------------
# dot
function fx_dot(x,y)
{
   z=""
   for(i=x;i<y;i++)
      z=z c0
   return z
}
# ------------------------------------------------------------------------------
# double spaced dot & right justify
function fx_dot2(x,y)
{
   z=""
   for(i=x;i<y;i++)
      if(i%2)                          # double space the dot
         if(y%2)                       # justify
            z=z" "
         else
            z=z c0
      else
         if(y%2)
            z=z c0
         else
            z=z" "
   return z
}
# ------------------------------------------------------------------------------
# bytes -> percent
function fx_p(x,y)
{
   l=length(x)
   xn=fx_e(substr(x,1,l-1),substr(x,l))

   l=length(y)
   yn=fx_e(substr(y,1,l-1),substr(y,l))

   return yn/xn
}
# ------------------------------------------------------------------------------
# z*10^n exponent -> bytes
function fx_e(z,ze)
{
   switch(ze)
   {
      case "P" :              # petabyte not there yet...
         zq=1000000000000000
         break
      case "T" :              # terrabyte
         zq=1000000000000
         break
      case "G" :              # gigabyte
         zq=1000000000
         break
      case "M" :              # megabyte
         zq=1000000
         break
      case "K" :              # kilobyte
         zq=1000
         break
      default :               # byte
         zq=1
   }
   return zq*z
}
# ==============================================================================
