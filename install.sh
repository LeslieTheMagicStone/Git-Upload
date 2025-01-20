#!/bin/bash

# Ensure the script is executable
chmod +x gitupload.sh
if [ $? -ne 0 ]; then
    echo "Failed to make gitupload.sh executable."
    exit 1
fi

# Create a symbolic link to /usr/local/bin
sudo ln -s "$(pwd)/gitupload.sh" /usr/local/bin/gitupload
if [ $? -ne 0 ]; then
    echo "Failed to create symbolic link."
    exit 1
fi

echo "gitupload command installed successfully."
