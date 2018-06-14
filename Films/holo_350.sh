#!/bin/bash
# make holographic video

# beaucoup d'aide de http://wiki.joanillo.org/index.php/Pyramid_hologram
# la video d'origine ($1) doit etre de 1440x1080

## crop vers un carré (centré) de 1080x1080
ffmpeg -y -i $1 -vf "crop=350:350:150:0" orig1.mp4

## création de videos avec rotation
# option transpose :
# 0 = 90CounterCLockwise and Vertical Flip (default)
# 1 = 90Clockwise
# 2 = 90CounterClockwise
# 3 = 90Clockwise and Vertical Flip
ffmpeg -y -i orig1.mp4 -y -b 10000k -vf "transpose = 1" orig2.mp4
ffmpeg -y -i orig1.mp4 -y -b 10000k -vf "transpose = 1, transpose = 1" orig3.mp4
ffmpeg -y -i orig1.mp4 -y -b 10000k -vf "transpose = 2" orig4.mp4

## mosaique
# filter_complex: https://trac.ffmpeg.org/wiki/Create%20a%20mosaic%20out%20of%20several%20input%20videos
# black bg: https://stackoverflow.com/questions/47042473/ffmpeg-complex-filter-multiple-crops-on-black-background
ffmpeg -y -i orig1.mp4 -i orig2.mp4 -i orig3.mp4 -i orig4.mp4 \
-b 10000k -filter_complex "
color=s=1440x1080:c=black[base];
[0:v] setpts=PTS-STARTPTS, scale=360x360 [up];
[1:v] setpts=PTS-STARTPTS, scale=360x360 [right];
[2:v] setpts=PTS-STARTPTS, scale=360x360 [bot];
[3:v] setpts=PTS-STARTPTS, scale=360x360 [left];
[base][up] overlay=shortest=1:x=540:y=0 [tmp2];
[tmp2][right] overlay=shortest=1:x=1080:y=360 [tmp3];
[tmp3][bot] overlay=shortest=1:x=540:y=720 [tmp4];
[tmp4][left] overlay=shortest=1:x=0:y=360" out.mp4
