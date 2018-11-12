#!/bin/bash

# See https://www.mail-archive.com/qemu-devel@nongnu.org/msg471657.html thread.
#
# The "pc-q35-2.4" machine type was changed to "pc-q35-2.9" on 06-August-2017.
#
# The "media=cdrom" part is needed to make Clover recognize the bootable ISO
# image.

##################################################################################
# NOTE: Comment out the "MY_OPTIONS" line in case you are having booting problems!
##################################################################################

MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

echo 1 > /sys/module/kvm/parameters/ignore_msrs

taskset -c 0,1 nice -n 15 qemu-system-x86_64 -enable-kvm -m 6G -mem-prealloc -mem-path /dev/hugepages/vm_macos \
          -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
	  -machine pc-q35-2.11 \
          -smp 2,sockets=1,cores=2,threads=1 \
          -vnc :0 \
	  -usb -device usb-kbd -device usb-tablet \
	  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
	  -drive if=pflash,format=raw,readonly,file=OVMF_CODE.fd \
	  -drive if=pflash,format=raw,file=OVMF_VARS-1024x768.fd \
	  -smbios type=2 \
	  -device ich9-intel-hda -device hda-duplex \
	  -device ide-drive,bus=ide.2,drive=Clover \
	  -drive id=Clover,if=none,snapshot=off,format=qcow2,file=./Clover.qcow2 \
	  -device ide-drive,bus=ide.1,drive=MacHDD \
	  -drive id=MacHDD,if=none,file=./osx_hdd.qcow2,format=qcow2 \
	  -netdev bridge,br=br0,id=n1 -device e1000-82545em,netdev=n1,mac=ec:b1:d7:42:87:b9 \
	  -monitor stdio

#          -spice port=5900,addr=0.0.0.0,disable-ticketing \

