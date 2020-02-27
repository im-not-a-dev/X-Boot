# XiaomiDualboot
A set of scripts to enable easy dualbooting on laptops which forceboot Windows on a single drive.

It works by renaming the Windows bootloader to something else so that the firmware doesn't recognise it as Windows.
The script requires administrative privilages.

For this to work, the script has to mount the EFI partition.
By default it is mounted on X:.
You can change this on line 33 of both .bat files.