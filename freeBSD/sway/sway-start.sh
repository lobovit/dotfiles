#!/bin/sh
UIDNUM="$(id -u)"
RUNDIR="/var/run/user/$UIDNUM"

exec dbus-run-session -- sh -lc '
  export XDG_CURRENT_DESKTOP=sway
  export XDG_RUNTIME_DIR="'$RUNDIR'"
  mkdir -p "$XDG_RUNTIME_DIR"; chmod 700 "$XDG_RUNTIME_DIR"

  # mata instâncias antigas (se houver)
  pkill -x xdg-desktop-portal xdg-desktop-portal-wlr wireplumber pipewire 2>/dev/null || true

  # sobe áudio/stream do usuário
  ( pgrep -x pipewire >/dev/null || pipewire ) &
  ( pgrep -x wireplumber >/dev/null || wireplumber ) &

  # espera o socket do pipewire aparecer
  for i in $(jot 20); do [ -S "$XDG_RUNTIME_DIR/pipewire-0" ] && break; sleep 0.1; done

  # backend + portal (nessa ordem)
  /usr/local/libexec/xdg-desktop-portal-wlr -l WARN >/tmp/xdpw.log 2>&1 &
  sleep 0.3
  /usr/local/libexec/xdg-desktop-portal -r   >/tmp/xdg-portal.log 2>&1 &

  exec sway
'
