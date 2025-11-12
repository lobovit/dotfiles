#!/bin/sh
# restart-network.sh
# Reinicia a interface de rede (default: re0) e reestabelece PipeWire/portais Wayland.
# Uso: sudo ./restart-network.sh [iface]
# Ex.: sudo ./restart-network.sh re0

set -u

IFACE="${1:-re0}"
UIDNUM="$(id -u)"
RUNDIR="/var/run/user/$UIDNUM"

echo "🔧 Reiniciando rede na interface: $IFACE"

# 1) Reinicia a interface e DHCP
ifconfig "$IFACE" down || true
sleep 1
ifconfig "$IFACE" up || true
sleep 1

# Tenta reiniciar o dhclient da interface; se não houver, chama direto
if pgrep -f "dhclient: $IFACE" >/dev/null 2>&1; then
  echo "↻ Reiniciando dhclient para $IFACE..."
  pkill -f "dhclient: $IFACE" || true
  sleep 1
fi
echo "📡 Solicitando/renovando DHCP em $IFACE..."
dhclient "$IFACE" || echo "⚠️ dhclient retornou não-zero (verifique /var/log/messages)."

echo "📋 Status atual da interface:"
ifconfig "$IFACE"

# 2) Reergue PipeWire, WirePlumber e os portais (sem reiniciar o Sway)
echo "🎛️ Re-sincronizando PipeWire/WirePlumber e xdg-desktop-portal(-wlr)..."
pkill -x xdg-desktop-portal xdg-desktop-portal-wlr wireplumber pipewire 2>/dev/null || true

# Garante XDG_RUNTIME_DIR válido (igual ao que seu launcher usa)
export XDG_RUNTIME_DIR="$RUNDIR"
mkdir -p "$XDG_RUNTIME_DIR" && chmod 700 "$XDG_RUNTIME_DIR"

# Sobe PipeWire/WirePlumber
( pgrep -x pipewire    >/dev/null || pipewire ) &
( pgrep -x wireplumber >/dev/null || wireplumber ) &

# Espera o socket do PipeWire aparecer
for i in $(jot 50); do
  [ -S "$XDG_RUNTIME_DIR/pipewire-0" ] && break
  sleep 0.1
done

# Backends do portal: primeiro o -wlr, depois o portal principal
/usr/local/libexec/xdg-desktop-portal-wlr -l WARN >/tmp/xdpw.log 2>&1 &
sleep 0.3
/usr/local/libexec/xdg-desktop-portal   -r      >/tmp/xdg-portal.log 2>&1 &

echo "✅ Rede e portais restabelecidos. (logs: /tmp/xdpw.log, /tmp/xdg-portal.log)"
