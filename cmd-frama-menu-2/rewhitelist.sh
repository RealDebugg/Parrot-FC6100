#!/system/bin/sh

userid=`id`
whitefile='/system/etc/whitelist.xml'

if [[ "${userid}" == "uid=0(root) gid=0(root)" ]]
   then if [[ ! -f ${whitefile}.lock ]]
           then remount=`mount | awk '/ \/system / {print "mount -o rw,remount -t "$3,$1,$2}'`
	        ${remount}
                touch ${whitefile}.lock

                if [[ -f ${whitefile}.lock ]]
                   then epoch=`date "+%s"`
                        packages=`pm list packages | cut -d: -f2`
                        whiteseparate=`grep -n '</user>' ${whitefile} | cut -d ":" -f1`
                        whitecutoff=`expr ${whiteseparate} - 1`
                        whitecount=`echo ${whitelist} | wc -w`

                        if [[ -f ${whitefile} ]]
                           then mv ${whitefile} ${whitefile}.${epoch}
                                head -n ${whitecutoff} ${whitefile}.${epoch} > ${whitefile}
                        fi

                        echo '  <!-- Added on '${epoch}' -->' >> ${whitefile}

                        for i in ${packages} 
                            do test=`grep \"${i}\" ${whitefile}.${epoch}`
                               if [[ -z "${test}" ]]
                                  then echo '  <package name="'${i}'"/>' >> ${whitefile}
                               fi
                        done

                        tail -n +${whiteseparate} ${whitefile}.${epoch} >> ${whitefile}
                        whitelist=`ls ${whitefile}.[0-9]*`

                        if [[ "${whitecount}" -gt 4 ]]
                           then whitesub=`expr ${whitecount} - 4`
                                whiteout=`echo ${whitelist} | sort | cut -d " " -f 1-${whitesub}`
                                rm ${whiteout}
                        fi

                        rm ${whitefile}.lock

                   else echo Cannot create lockfile. 

                fi

          else echo Lockfile exists.

       fi

    else echo Must be root.

fi
