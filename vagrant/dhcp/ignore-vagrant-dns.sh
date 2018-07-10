if [[ -L /etc/resolv.conf ]]
then
    rm /etc/resolv.conf
fi

cat <<EOF > /etc/resolv.conf
search $VAGRANT_DHCP_DOMAIN
nameserver $VAGRANT_DHCP_IP
EOF

chown root:root /etc/resolv.conf
chmod 644 /etc/resolv.conf
chattr +i /etc/resolv.conf
