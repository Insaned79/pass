#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking passwords
OFS=$IFS
IFS="
"
/usr/bin/ld.bfd -b elf64-x86-64 -m elf_x86_64  --dynamic-linker=/lib64/ld-linux-x86-64.so.2    -L. -o passwords link.res
if [ $? != 0 ]; then DoExitLink passwords; fi
IFS=$OFS
echo Linking passwords
OFS=$IFS
IFS="
"
/usr/bin/objcopy --only-keep-debug passwords passwords.dbg
if [ $? != 0 ]; then DoExitLink passwords; fi
IFS=$OFS
echo Linking passwords
OFS=$IFS
IFS="
"
/usr/bin/objcopy --add-gnu-debuglink=passwords.dbg passwords
if [ $? != 0 ]; then DoExitLink passwords; fi
IFS=$OFS
echo Linking passwords
OFS=$IFS
IFS="
"
/usr/bin/strip --strip-unneeded passwords
if [ $? != 0 ]; then DoExitLink passwords; fi
IFS=$OFS
