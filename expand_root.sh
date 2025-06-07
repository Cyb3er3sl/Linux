#!/bin/bash

# Detect VG and LV names
VG_NAME=$(sudo vgdisplay | grep "VG Name" | awk '{print $3}')
LV_PATH=$(sudo lvdisplay | grep "LV Path" | awk '{print $3}' | head -n1)

echo "Detected Volume Group (VG): $VG_NAME"
echo "Detected Logical Volume (LV): $LV_PATH"

read -p "Do you want to proceed and expand the root volume? (y/n): " answer
if [[ $answer != "y" && $answer != "Y" ]]; then
  echo "Operation cancelled."
  exit 1
fi

# Expand the logical volume
echo "Expanding the logical volume..."
sudo lvextend -l +100%FREE "$LV_PATH"

# Resize the filesystem
echo "Resizing the filesystem..."
sudo resize2fs "$LV_PATH"

echo "✅ Done! Check new space with: df -h /"
