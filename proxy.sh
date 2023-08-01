#!/bin/bash

# Remote server details
remote_server="167.71.215.84"  # Replace with the IP address or hostname of the remote server
remote_port="22"                # Replace with the SSH port if it's not the default (port 22)

# Local proxy details
local_port="8080"               # Replace with your preferred local port for the proxy (e.g., 8888)

# Function to check if SSH is available
check_ssh() {
  if ! command -v ssh &>/dev/null; then
    echo "SSH is not installed. Please install OpenSSH to use the proxy."
    exit 1
  fi
}

# Function to start the proxy
start_proxy() {
  check_ssh
  echo "Starting the proxy..."
  ssh -N -D "$local_port" "$remote_server" -p "$remote_port"
}

start_proxy
