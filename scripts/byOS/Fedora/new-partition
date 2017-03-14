#!/bin/sh
#
# Adds a new partition to a device mapper volume group
#
# Usage ..... new-partition <device> <volume group> <logical volume name> [mounting point]
# Example ... new-partition /dev/sdb1 centos_dwellers wharf /wharf
#        (or) new-partition /dev/sdb1 centos_dwellers wharf
#
# If mounting point is omitted, disk is mounted in /<logical volume name>
#

# Parses arguments

if [ $# -lt 3 ] || [ $# -gt 4 ]; then
    echo 'Usage: new-partition <device> <volume group> <logical volume name> [mounting point]'
    exit 1
fi

DEVICE=$1
VG=$2
LVNAME=$3

if [ $# -eq 4 ]; then
    MOUNTING_POINT=$4
else
    MOUNTING_POINT=/$LVNAME
fi

pvcreate "$DEVICE"
vgextend "$VG" "$DEVICE"
lvcreate -l 100%FREE -n "$LVNAME" "$VG"
mkfs -t xfs "/dev/$VG/$LVNAME"
cat "/dev/mapper/$VG-$LVNAME $MOUNTING_POINT xfs defaults 1 2" >> /etc/ftab
mount "$MOUNTING_POINT"
