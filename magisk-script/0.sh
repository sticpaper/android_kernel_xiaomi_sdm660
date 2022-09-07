#!/system/bin/sh
MODDIR=${0%/*}

# Set the target swappiness value (>= 4GB memory)
echo 180 > /proc/sys/vm/swappiness

# Reset read_ahead_kb parameter after init.qcom.post_boot.sh
# Description from Jaegeuk Kim: 
# It's a known issue that large readahead brings memory pressure problem.
echo 128 > /sys/block/mmcblk0/queue/read_ahead_kb
echo 128 > /sys/block/mmcblk0rpmb/queue/read_ahead_kb
if [ -f /sys/block/mmcblk1/queue/read_ahead_kb ]; then
	echo 128 > /sys/block/mmcblk1/queue/read_ahead_kb
fi

# If it is a block encrypted state, the data is mounted by the device mapper
# Therefore, you also need to set read-ahead parameters for dm-0(userdata)
if [ -f /sys/block/dm-0/queue/read_ahead_kb ]; then
	echo 128 > /sys/block/dm-0/queue/read_ahead_kb
fi

# limit discard size to 128MB in order to avoid long IO latency
echo 134217728 > /sys/block/mmcblk0/queue/discard_max_bytes

# Our device supports external SD card, so also set discard parameter for SD card
# limit discard size to 128MB in order to avoid long IO latency
if [ -f /sys/block/mmcblk1/queue/discard_max_bytes ]; then
	echo 134217728 > /sys/block/mmcblk1/queue/discard_max_bytes
fi

# If it is a block encrypted state, the data is mounted by the device mapper
# Therefore, you also need to set discard_max_bytes parameters for dm-0(userdata)
# limit discard size to 128MB in order to avoid long IO latency
if [ -f /sys/block/dm-0/queue/discard_max_bytes ]; then
	echo 134217728 > /sys/block/dm-0/queue/discard_max_bytes
fi
