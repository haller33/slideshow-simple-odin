#!/bin/bash

set -x

mkdir -p bin

if [ $# -eq 2 ]; then

    odin build src -out:bin/slideshow-simple.bin -o:speed -reloc-mode:static && echo "OK"

elif [ $# -eq 1 ]; then

    odin build src -debug -out:bin/slideshow-simple.bin && echo "OK"
else

    odin build src -out:bin/slideshow-simple.bin && echo "OK"

fi
