#!/bin/bash

# canvaswrap.sh
#
# MIT License (c.f. LICENSE file for details)
#
# Copyright (c) 2018 gutschke
#
# ImageMagick is an incredibly powerful image manipulation tool. Unfortunately,
# it also tends to be difficult to use. This script shows how to expand an
# image file by mirroring its contents along the edges. This is needed when
# mounting a canvas in "gallery" style.
#
# The script takes the name of an input file, the thickness of the border
# on the left and right side, and the thickness of the border on the top and
# bottom (in pixels). And finally, it takes an output file name.

if [ "$#" -ne 4 -o \! -r "$1" ]; then
  echo "Usage: ${0##*/} <imagefile> <horizontal pixels> <vertical pixels> <outputfile>" >&2
  exit 1
fi

# ImageMagick already knows how to do canvas wrapping. It just doesn't make it
# particularly obvious how to access this feature.
#
# The hard work is being done by the "-virtual-pixel" function which
# can be asked to add mirrored pixels all around our image. But these pixels
# are only virtual. They are accessible to other ImageMagick operators that
# look up pixel values, but they don't actually exist, if we were to write
# the image to disk.
#
# Cloning the original image and expanding it is an easy way to create a
# suitably sized temporary canvas to draw onto. We then use the "-fx" operator
# to copy the virtual pixels onto this canvas.
exec convert "$1" '(' +clone -bordercolor white -border "$2x$3" ')' \
             +swap -virtual-pixel mirror -fx "v.p[-$2,-$3]" "$4"
