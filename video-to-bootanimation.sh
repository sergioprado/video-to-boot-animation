#!/bin/sh

# How to call this script
#   ./video-to-bootanimation.sh <video_file> <res_x> <res_y> <fps>
# Where:
#   <video_file>  video file
#   <res_x>       display X resolution
#   <res_y>       display Y resolution
#   <fps>         video frames per second (get it with ffmpeg -i)
# Example:
#   ./video-to-bootanimation.sh video.mpeg 1280 720 30

# parameters
VIDEO=$1
RES_X=$2
RES_Y=$3
FPS=$4

OUT_DIR=.bootanimation
IMAGES_DIR=$OUT_DIR/part0
DESC_FILE=$OUT_DIR/desc.txt

# cleanup
rm -rf $OUT_DIR bootanimation.zip

# initialize output directory
mkdir -p $IMAGES_DIR

# extract frames from the video
ffmpeg -i $VIDEO $IMAGES_DIR/00%05d.png

# resize images
for f in $IMAGES_DIR/*.png; do
    mogrify -resize ${RES_X}x${RES_Y} $f
done

# create desc.txt file
echo "$RES_X $RES_Y $FPS" > $DESC_FILE
echo "p 0 0 part0" >> $DESC_FILE

# Create the bootanimation
cd $OUT_DIR
zip -r0 ../bootanimation.zip *
cd -

# cleanup
rm -rf $OUT_DIR
