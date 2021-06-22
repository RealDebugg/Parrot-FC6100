#!/system/bin/sh
userid=`id`
usage="Usage ${0} [system-ro|system-rw|cache-sd|cache-og] [feedback]"

if [[ "${userid}" == "uid=0(root) gid=0(root)" ]]
   then  if [[ ! -f /data/local/remount.original ]] 
            then mount > /data/local/remount.original
         fi

         if [[ ! -z "${1}" ]]
            then if [[ "${1}" == "system-ro" ]]
                 then remount=`mount | awk '/ \/system / {print "mount -o ro,remount -t",$3,$1,$2}'`
                      mounter=' /system '
                 fi 
                 if [[ "${1}" == "system-rw" ]]
                    then remount=`mount | awk '/ \/system / {print "mount -o rw,remount -t",$3,$1,$2}'`
                         mounter=' /system '
                 fi
                 if [[ "${1}" == "cache-sd" ]]
                    then remount=`mount | awk '/ \/mnt\/sdcard / {print "mount -t",$3,$1,"/cache"}'`
                         mounter=' /cache '
                         umount /cache
                 fi
                 if [[ "${1}" == "cache-og" ]]
                    then remount=`cat /data/local/remount.original | awk '/ \/cache / {sub(/,relatime/,""); print "mount -o",$4,"-t",$3,$1,$2}'`
                         mounter=' /cache '
                         umount /cache
                 fi
                 if [[ ! -z "${remount}" ]]
                    then ${remount}
                         if [[ "${2}" == "feedback" ]]
                            then echo ${remount}
                                 mount | grep ${mounter}
                         fi
                    else echo ${usage}
                 fi
            else echo ${usage}
         fi
    else echo "Must be root"
fi
