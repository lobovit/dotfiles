#!/bin/sh
# restart-network.sh
# Reinicia a interface de rede re0 no FreeBSD

IFACE="re0"

echo "Reiniciando a interface $IFACE..."

# Desliga a interface
ifconfig "$IFACE" down
sleep 1

# Liga novamente
ifconfig "$IFACE" up
sleep 1

# Renova o endereço via DHCP (caso use DHCP)
if service -e | grep -q dhclient; then
    echo "Renovando DHCP..."
    service dhclient restart "$IFACE"
else
    echo "Solicitando novo endereço DHCP..."
    dhclient "$IFACE"
fi

# Exibe o status atual
echo "Status atual da interface:"
ifconfig "$IFACE"

echo "Rede reiniciada com sucesso."
