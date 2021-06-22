# Parrot-FC6100
Public repository containing research for the Parrot FC6100 chipset, including Volvo Sensus Connect and SAAB iQon (Android SDK 10 / Android 2.3.3)


**<ins>This thread is research and development on several topics and has already some nice answers:</ins>**

The starting questions:

1. How to get ADB working ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)

2. How to install .apk files ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)

3. How to root ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+)


**WARNING!:** 

**The below mentioned method is an experimental way of rooting. Rooting your SCT involves some android knowledge. Me, the developers and anyone in this topic are not responsible for typo's or any damage that may occur when you follow these instructions.**
**ROOTING means you have complete control over the android system. This also means you can do damage to it.**

**Security warning:**
**The SCT has ADB over WIFI enabled by default. Never ever connect your Volvo SCT to an unknown and/or untrusted network! Anyone connected to that same network can harm your Volvo SCT. The same applies for connecting unknown people to a known/trusted network of yours.**
**Security warning 2:**
**If your ROOTED your SCT, you are extra vulnerable to above. Anyone with ADB on the same network has complete control over your SCT!**

**WARNING!**

**Do NOT attempt to replace the SCT's BUSYBOX executable or the command symlinks to it. Another user in this forum just sent me a private message stating that they tried this on their SCT and can no longer mount USB drives or connect to ADB over WiFi. Apparently, they also do not have a File Explorer or a Terminal Emulator installed so it seems this is going to be nearly impossible to fix and will most likely be required to swap it at the dealer.**




The below answers are not yet completely reviewed and tested. The answers will be reviewed in the next days. In any case the instructions below are delivered "as is" and have no guaranty. If you follow the instructions below, you are responsible for your own actions. So, before you do so, understand, or at least try to, what you are doing. If you have questions or have recommendations, post them in the topic.

# **<ins>Instructions to root en install apps:</ins>**

Note: Instructions are tested on specific versions of the Volvo SCT
It is possible that these instructions below are not (yet) working on other versions: Other continents, newer versions etc.
If you tested it on a different continent + version, let me know, so I can put it here.

Available versions:

EU

-1.47.88 ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) Tested

-1.47.96 ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) Tested

-1.49.34 ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) Tested

 - **One click script version 4 in attachments cmd-frama-menu-4.zip (4.62 MB)**


It is rather simple as long as You have the SENSUS CONNECTED TOUCH and a PC (prefer a laptop) which You need to connect to the same network.

How to:
1. **Preparing**

*Download the: **cmd-frama-menu-4.zip** from the page 1, first post attachments. [link](https://github.com/RealDebugg/Parrot-FC6100/tree/master/cmd-frama-menu-4/menu)

2. **Follow the instructions**

The instructions are rather simple.
-Connect your SCT to the same Wifi network as your PC. This wifi network can be your home network or your local hotspot from your phone.
-Unzip the **(cmd-frama-menu-4.zip)** and start menu.bat found in the folder "menu"
- After starting menu.bat on your pc it will ask:
Code:
Input {IP Address of Android Device} or USB:
Type in the IP address of the SCT, **<ins>can be found when You go to the settings on SCT -> WIFI -> and click on the connected network (starts with 192.-).</ins>**
After that the menu look list this: **<ins>(Now just type in: 1 and wait a bit so it will say complete, then type in 2 and wait a bit until complete and so on, until step 6 when the SCT will restart itself)</ins>**
Code:
1 - Copy Framaroot files and execute.
2 - Install remount.sh into /system/xbin and remount as writeable.
3 - Alter /system/build.prop to ro.parrot.install-all=true
4 - Install Google Framework & Android Market
5 - Install rewhitelist.sh/setpropex/patch init.parrot.capabilities.sh
6 - Reboot Android Device
7 - Install Android Packages from APKs folder.
8 - Android Debug Bridge Shell
9 - Save ADB Bugreport to Disk
R - Input connection information & retry ADB connect.
Q - Quit
Run steps 1 through 6 in order to root the SCT.
Step 7 is optional and will install all APKs you have placed inside the APKs folder in your unzipped menu.zip folder on your pc PC.
Step 8 is for manual commands or troubleshooting.
Step 9 is for troubleshooting.
Step R is only needed when the connection to the SCT seems lost.

3. **You should have now a rooted SCT.**

4. **Installing applications**
I noticed that lots of Apps from Google Play Store can not be downloaded directly to the SCT (because the SCT is not in the available list of the apps) so a easy way is to download the Applications as ".apk" files from the PC (You can find the desired app from: http://www.appsapk.com/ or http://www.androiddrawer.com/ for example).
Then copy-paste these .apk files(make sure they do not have any spaces in the filenames) to the folder "APKs" found in the downloaded unzipped folder "cmd-frama-menu-4". To install them, run the menu.bat again and once connected with the SCT again run the step 7 to install the applications You copied to the APK folder.

If you want to install apps using the Google Play Store that are larger than 7MB or so, you need to remap the cache directory to the SD card:

> remount.sh cache-sd

Then after the app installation has finished, but before you start the app, remap the cache directory to the internal SCT memory:

> remount.sh cache-og


5. **Enable displaying applications while driving (disable safety feature)**

1. Download <ins>Android Terminal Emulator</ins> from Google Play Store on Your rooted SCT.
2. Once installed, run Android Terminal Emulator under Applications
3. touch the screen - the keyboard pops up
4. Type in "su" press ENTER
5. It should ask wether You allow Superuser or not, choose the "Allow" option.
6. Type in "rewhitelist.sh" press ENTER
7. Type in "reboot" press ENTER

6. **Enable Google Maps and Voice Search**
First install google.maps.6.14.4.apk by the method explained above. Then copy libvoicesearch.so to /system/lib and install Voice_Search_2.1.4.apk. These files can be found in Voice_Search_2.1.4.zip.
Here is an example of how to do this with adb:

> adb connect [ip of your SCT]

> adb push google.maps.6.14.4.apk /mnt/sdcard

> adb install /mnt/sdcard/google.maps.6.14.4.apk

> adb push libvoicesearch.so /mnt/sdcard

> adb shell su -c 'remount.sh system-rw'

> adb shell su -c 'cp /mnt/sdcard/libvoicesearch.so /system/lib'

> adb shell su -c 'chmod 644 /system/lib/libvoicesearch.so'

> adb push Voice_Search_2.1.4.apk /mnt/sdcard

> adb install /mnt/sdcard/Voice_Search_2.1.4.apk

Now #reboot# and Google Maps and Voice Search should be working. 

Now You should be done. Happy downloading and drive safely. :)

**Older instructions, just for reference here, do not follow anymore.**

[*]One click script for version 1.49.34: [LINK](https://github.com/RealDebugg/Parrot-FC6100/tree/master/cmd-frama-menu-2)

gekkekoe123 said:
Actually it was fine (since we are in the root folder), but since I was too lazy, I used your file. I had to correct the "true" to 1.
I also changed the menu to do this. I removed the set prop option, it's not needed anymore. Setpropex should also work on older versions.

Btw, I did the upgrade manually using adb shell, and did not used the menu.bat.
So if anyone could test it or double check the menu.bat file, it should be fine. I translated the manual commands back into the menu.bat

My SCT is upgraded and I am able to install apks :) Let's find out if waze lost of data is fixed. Also adjusting screen dpi is still working. But we now have setpropex so we can override everything ;)

When you finished step 5, you need to reboot in order to be able to install apks.

As allways: no guarantee and at your own risk when using the tools
Click to expand...





> **FAQ**
   1. Audio is not working when using application X
       This is a feature or limitation by design
        - TomTom and other navigation apps will break Sound/Audio due to this feature.
   2. If you have more, PM me or react in topic

> **TIPS**
    1. Use a USB keyboard in combination with ES file explorer or a Shell app to edit files on the system.
    2. If you have more, PM me or react in topic



How to unpack the update (.plf) files:
Download the [plftool](https://github.com/RealDebugg/Parrot-FC6100/tree/master/Parrot)
Basically, download, unzip, and go into the command line, the binaries directory and use the command syntax, "plftool -i -o "
