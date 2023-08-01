#!/bin/bash

# Remote server details
remote_server="159.223.92.20"  # Replace with the IP address or hostname of the remote server
remote_port="22"                # Replace with the SSH port if it's not the default (port 22)

# Local proxy details
local_port="8080"               # Replace with your preferred local port for the proxy (e.g., 8888)

# Start the SSH tunnel for the proxy
ssh -N -D "$local_port" "$remote_server" -p "$remote_port"
