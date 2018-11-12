ip link add br0 type bridge
ip addr flush dev eno1
ip link set eno1 master br0
ip tuntap add dev tap0 mode tap user $(whoami)
ip link set tap0 master br0
ip link set dev br0 up
ip link set dev tap0 up
dhclient