#!/bin/sh
# collect-crash-info.sh — FreeBSD quick SOS to clipboard (Wayland/wl-copy)
# deps: wl-clipboard (wl-copy), pciconf, kldstat, swaymsg (opcional), ZFS cmds (opcionais)
set -eu

OUTFILE="$(mktemp /tmp/sysreport-XXXXXX.txt)"

section() {
  printf "\n===== %s =====\n" "$1" >>"$OUTFILE"
}

run() {
  section "$1"
  # Comando exibido no relatório:
  printf "[$] %s\n\n" "$2" >>"$OUTFILE"
  # Executa e anexa (sem matar caso falhe):
  (sh -c "$2") >>"$OUTFILE" 2>&1 || true
}

# Cabeçalho
{
  echo "FreeBSD Troubleshoot Snapshot"
  echo "Host: $(hostname)"
  echo "Date: $(date -u) (UTC) / $(date)"
} >>"$OUTFILE"

# Sistema
run "Kernel e SO" \
  "uname -a && sysctl -n kern.ostype kern.osrelease kern.osrevision kern.bootfile 2>/dev/null"
run "Hardware resumido" \
  "sysctl -n hw.model hw.ncpu hw.physmem 2>/dev/null"
run "Uptime e carga" \
  "uptime && sysctl -n vm.loadavg 2>/dev/null"

# Boot / Kernel / Módulos
run "Mensagens do kernel (dmesg)" "dmesg -a"
run "dmesg.today (últimas 400 linhas, se existir)" "tail -n 400 /var/log/dmesg.today"
run "Módulos carregados" "kldstat"

# Logs do sistema (limitados)
run "/var/log/messages (últimas 600 linhas)" "tail -n 600 /var/log/messages"
run "rc boot log (se existir)" "tail -n 300 /var/log/rc.log"

# Wayland / Sway (opcional)
run "Sway versão" "command -v swaymsg >/dev/null && swaymsg -t get_version || echo 'swaymsg não disponível'"
run "Sway saídas" "command -v swaymsg >/dev/null && swaymsg -t get_outputs || echo 'swaymsg não disponível'"
run "Variáveis Wayland" "env | grep -E 'WAYLAND|XDG_SESSION_TYPE|XDG_CURRENT_DESKTOP'"

# GPU / PCI
run "PCI (detalhado)" "pciconf -lv"
run "DRM/AMDGPU sysctl (se existirem)" "sysctl -a 2>/dev/null | egrep -i 'dev\.drm|hw\.amdgpu|hw\.radeon' || true"

# Armazenamento / ZFS
run "Discos e partições" "geom disk list; gpart show -l"
run "Montagens e uso" "mount; df -h; swapinfo -h"
run "ZFS status (se houver)" "command -v zpool >/dev/null && (zpool status -x; echo; zpool status) || echo 'ZFS não instalado'"
run "ZFS datasets (top 50)" "command -v zfs >/dev/null && zfs list | head -n 50 || echo 'ZFS não instalado'"

# Rede
run "Interfaces" "ifconfig -a"
run "Rotas" "netstat -rn"
run "Últimos DHCP/dhclient (se houver)" "grep -hE 'dhclient|DHCP' /var/log/* 2>/dev/null | tail -n 200"

# Processos / Memória
run "Resumo de memória/VM" "vmstat -s"
run "Processos topo (1 snapshot)" "top -b -n 1 2>/dev/null || ps aux"

# Pacotes úteis (opcional)
run "Pacotes Wayland/DRM (se instalados)" "pkg info 2>/dev/null | egrep -i 'wayland|wl-clipboard|sway|wlroots|drm|amdgpu' || true"

# Panics/temperatura (se expostos via sysctl)
run "Possíveis panics e temperaturas" "sysctl -a 2>/dev/null | egrep -i 'panic|traceback|dev\.cpu\.[0-9]+\.temperature' || true"

# Kenv (firmware/SMBIOS útil p/ suporte)
run "kenv resumo" "kenv 2>/dev/null | egrep -i 'smbios|loader|boot|efi|acpi' || kenv 2>/dev/null || true"

# Copia para clipboard via wl-copy, se possível
COPIED=0
if command -v wl-copy >/dev/null 2>&1 && [ -n "${WAYLAND_DISPLAY-}" ]; then
  if cat "$OUTFILE" | wl-copy; then
    COPIED=1
  fi
fi

echo ""
echo "Relatório salvo em: $OUTFILE"
if [ "$COPIED" -eq 1 ]; then
  echo "✓ Também foi copiado para o clipboard (wl-copy). Basta colar (Ctrl+V)."
else
  echo "⚠ wl-copy indisponível ou fora de sessão Wayland. O arquivo acima contém tudo."
fi
