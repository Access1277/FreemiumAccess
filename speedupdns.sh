#!/data/data/com.termux/files/usr/bin/bash

# Set custom DNS servers (replace the IP addresses with the desired DNS servers)
DNS_SERVER_1="api.ssh.elcavlaw.com"
DNS_SERVER_2="api.ovpn.elcavlaw.com"

# Create the custom resolv.conf file
echo "nameserver $DNS_SERVER_1" > ~/.resolv.conf
echo "nameserver $DNS_SERVER_2" >> ~/.resolv.conf

# Export RESOLV_CONF environment variable to use the custom resolv.conf
export RESOLV_CONF=~/.resolv.conf

# Test DNS resolution (you can replace 'example.com' with the domain you want to check)
dig example.com

# Add this script to your .bashrc or .bash_profile to apply the DNS settings every time you start Termux
# echo "source /path/to/speedupdns.sh" >> ~/.bashrc
# OR
# echo "source /path/to/speedupdns.sh" >> ~/.bash_profile
