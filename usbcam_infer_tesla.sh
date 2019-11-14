#!/bin/sh

#
# MIT License
# 
# Copyright (c) 2019 MACNICA Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

if [ "$#" -ge 2 ]
then
    WIDTH=$1
    HEIGHT=$2
else
    WIDTH=1280
    HEIGHT=720
fi

DS_PATH="/opt/nvidia/deepstream/deepstream-4.0"
INFER_CFG="$DS_PATH/sources/apps/sample_apps/deepstream-test1/dstest1_pgie_config.txt"

gst-launch-1.0 \
nvstreammux name="srcmux" width=$WIDTH height=$HEIGHT batch-size=1 live-source=true ! \
nvinfer config-file-path=$INFER_CFG ! \
"video/x-raw(memory:NVMM), format=NV12" ! \
nvvideoconvert ! \
"video/x-raw(memory:NVMM), format=RGBA" ! \
nvdsosd ! \
nveglglessink \
v4l2src device="/dev/video0" ! \
"video/x-raw, width=$WIDTH, height=$HEIGHT" ! \
videoconvert ! \
"video/x-raw, format=(string)NV12" ! \
nvvideoconvert ! \
"video/x-raw(memory:NVMM), format=NV12" ! \
srcmux.sink_0
