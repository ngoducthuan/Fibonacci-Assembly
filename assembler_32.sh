#!/bin/bash

fileName="${1%%.*}" # remove .s extension

nasm -f elf ${fileName}".s"
ld ${fileName}".o" -m elf_i386 -o ${fileName}
[ "$2" == "-g" ] && gdb -q ${fileName} || ./${fileName}
