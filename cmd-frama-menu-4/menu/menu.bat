@ECHO OFF

SET INPUT=%1
IF "%INPUT%"=="" GOTO GETINPUT

:CHECKINPUT
IF "%INPUT%"=="" GOTO NOINPUT
IF "%INPUT%"=="usb" GOTO BEGIN
IF "%INPUT%"=="USB" GOTO BEGIN

bin\adb connect %INPUT%

:BEGIN
CLS
bin\adb devices

:START
ECHO 1 - Copy Framaroot files and execute.
ECHO 2 - Install remount.sh into /system/xbin and remount as writeable.
ECHO 3 - Alter /system/build.prop to ro.parrot.install-all=true
ECHO 4 - Install Google Framework ^& Android Market
ECHO 5 - Install rewhitelist.sh/setpropex/patch init.parrot.capabilities.sh
ECHO 6 - Reboot Android Device
ECHO 7 - Install Android Packages from APKs folder.
ECHO 8 - Android Debug Bridge Shell
ECHO 9 - Save ADB Bugreport to Disk
ECHO R - Input connection information ^& retry ADB connect.
ECHO Q - Quit
ECHO.
CHOICE /N /C:123456789rq /M "MAKE A SELECTION (1, 2, 3, 4, 5, 6, 7, 8, 9, R or Q)"%2
ECHO.
IF ERRORLEVEL ==11 GOTO QUIT
IF ERRORLEVEL ==10 GOTO GETINPUT
IF ERRORLEVEL ==9 GOTO REPORT
IF ERRORLEVEL ==8 GOTO SHELL
IF ERRORLEVEL ==7 GOTO INSTALL
REM IF ERRORLEVEL ==7 GOTO INSTALLAPK
IF ERRORLEVEL ==6 GOTO REBOOT
IF ERRORLEVEL ==5 GOTO WHITELIST
IF ERRORLEVEL ==4 GOTO MARKET
IF ERRORLEVEL ==3 GOTO BUILDPROP
IF ERRORLEVEL ==2 GOTO REMOUNT
IF ERRORLEVEL ==1 GOTO FRAMAROOT
GOTO END

:QUIT
bin\adb kill-server
GOTO END

:REBOOT
ECHO Rebooting Android device
bin\adb reboot
ECHO.
PAUSE
GOTO BEGIN

:REPORT
ECHO Saving data into bugreport.txt file.  This may take a minute.
bin\adb bugreport > bugreport.txt
ECHO Done
ECHO.
PAUSE
GOTO BEGIN

:SHELL
bin\adb shell
ECHO.
PAUSE
GOTO BEGIN

:INSTALL
ECHO Installing Android Packages from APKs folder
for /f %%i in ('dir /b APKs\*.apk') do (
        bin\adb install APKs\%%i
)  
ECHO.
PAUSE
GOTO BEGIN

:INSTALLAPK
ECHO Installing APK in apks folder
for /f %%i in ('dir /b apks') do (
	bin\adb push apks\%%i /data/local/tmp/.
	bin\adb shell su root -c 'cp /data/local/tmp/%%i /system/app/.'
	bin\adb shell su root -c 'chmod 644 /system/app/%%i'
)  
ECHO.
PAUSE
GOTO BEGIN

:WHITELIST
ECHO Pushing rewhitelist.sh to /data/local/tmp
bin\adb push rewhitelist.sh /data/local/tmp/.
bin\adb push setpropex /data/local/tmp/.
ECHO.
ECHO Copying script to /system/xbin
bin\adb shell su -c 'cp /data/local/tmp/rewhitelist.sh /system/xbin/.'
bin\adb shell su -c 'cp /data/local/tmp/setpropex /system/xbin/.'
ECHO.
ECHO Removing script from /data/local/tmp
bin\adb shell su -c 'rm /data/local/tmp/rewhitelist.sh'
bin\adb shell su -c 'rm /data/local/tmp/setpropex'
ECHO.
ECHO Changing script permissions
bin\adb shell su -c 'chmod 755 /system/xbin/rewhitelist.sh'
bin\adb shell su -c 'chmod 755 /system/xbin/setpropex'
bin\adb shell su -c 'ls -l /system/xbin/rewhitelist.sh /system/xbin/setpropex'
ECHO.
ECHO Making backup of /etc/init.parrot.capabilities.sh
bin\adb pull /etc/init.parrot.capabilities.sh
bin\adb shell su -c 'cp /etc/init.parrot.capabilities.sh /etc/init.parrot.capabilities.sh.bak'
ECHO.
ECHO Patching /etc/init.parrot.capabilities.sh
bin\adb shell su -c "sed -i '/^#!/a /system/xbin/setpropex ro.parrot.install.allow-all 1' /etc/init.parrot.capabilities.sh"
ECHO.
ECHO Making backups of /etc/permissions/whitelist.xml
bin\adb pull /etc/whitelist.xml
ECHO.
ECHO Excuting script
bin\adb shell su -c 'rewhitelist.sh'
PAUSE
GOTO BEGIN

:MARKET
ECHO Pushing Google Services Framework to /data/local/tmp
bin\adb push GoogleServicesFramework-2.2.1.apk /data/local/tmp/.
ECHO.
ECHO Copying Google Services Framework to /system/app
bin\adb shell su root -c 'cp /data/local/tmp/GoogleServicesFramework-2.2.1.apk /system/app/.'
ECHO.
ECHO Removing Google Services Framework from /data/local/tmp
bin\adb shell su root -c 'rm /data/local/tmp/GoogleServicesFramework-2.2.1.apk'
ECHO.
ECHO Pushing Android Market to /data/local/tmp
bin\adb push Market-3.3.11.apk /data/local/tmp/.
ECHO.
ECHO Copying Android Market to /system/app
bin\adb shell su root -c 'cp /data/local/tmp/Market-3.3.11.apk /system/app/.'
ECHO.
ECHO Removing Android Market from /data/local/tmp
bin\adb shell su root -c 'rm /data/local/tmp/Market-3.3.11.apk'
ECHO.
ECHO Modifying permissions for Google Services Framework ^& Android Market
bin\adb shell su root -c 'chmod 644 /system/app/GoogleServicesFramework-2.2.1.apk /system/app/Market-3.3.11.apk'
bin\adb shell su root -c 'ls -l /system/app/GoogleServicesFramework-2.2.1.apk /system/app/Market-3.3.11.apk'
ECHO.
PAUSE
GOTO BEGIN

:BUILDPROP
ECHO Making backups of /system/build.prop
bin\adb pull /system/build.prop
bin\adb shell su -c 'cp /system/build.prop /system/build.prop.bak'
ECHO.
ECHO Changing ro.parrot.install.allow-all from false to true
bin\adb shell su -c "sed -i 's/ro.parrot.install.allow-all=false/ro.parrot.install.allow-all=true/' /system/build.prop"
bin\adb shell grep install.allow /system/build.prop
ECHO.
PAUSE
GOTO BEGIN

:REMOUNT
ECHO Pushing remount.sh script to /data/local/tmp directory.
bin\adb push remount.sh /data/local/tmp/.
ECHO.
ECHO Changing permissions to script 
bin\adb shell su -c 'chmod 755 /data/local/tmp/remount.sh'
ECHO.
ECHO Remounting /system directory.
bin\adb shell su -c '/data/local/tmp/remount.sh system-rw feedback'
ECHO.
ECHO Copying script to /system/xbin directory.
bin\adb shell su -c 'cp /data/local/tmp/remount.sh /system/xbin/.'
bin\adb shell su -c 'ls -l /system/xbin/remount.sh'
ECHO.
ECHO Removing /data/local/tmp/remount.sh
bin\adb shell su -c 'rm /data/local/tmp/remount.sh'
ECHO.
PAUSE
GOTO BEGIN

:FRAMAROOT
ECHO Pushing libframalib.so to /data/local
bin\adb push libframalib.so /data/local/.

ECHO.
ECHO Pushing sploit.jar to /data/local/.
bin\adb push sploit.jar /data/local/.

ECHO.
ECHO Creating /data/local/tmp/dalik-cache directory
bin\adb shell mkdir /data/local/tmp/dalvik-cache

ECHO.
ECHO Executing FramaAdbActivity
bin\adb shell ANDROID_DATA=/data/local/tmp LD_LIBRARY_PATH=/data/local dalvikvm -cp /data/local/sploit.jar com.alephzain.framaroot.FramaActivity
ECHO.
PAUSE
GOTO BEGIN

:GETINPUT
set /p INPUT="Input {IP Address of Android Device} or USB: "
GOTO CHECKINPUT

:NOINPUT
ECHO.
ECHO Usage %0 (ip address ^| usb)
ECHO (eg., %0 192.168.0.2 or %0 usb)
ECHO.
PAUSE
:END