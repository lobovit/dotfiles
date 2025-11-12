#!/bin/sh
#
# update-freebsd.sh — mantém o FreeBSD sempre atualizado
# Autor: Vitor Lobo Ramos
# Uso: sudo sh update-freebsd.sh
#

# Parar se algum comando falhar
set -e

echo "=========================================="
echo " 🐚 Atualizando FreeBSD ($(date))"
echo "=========================================="

# 1. Verificar se está como root
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ Este script precisa ser executado como root (use sudo)."
    exit 1
fi

# 2. Fazer backup rápido das configs críticas
BACKUP_DIR="/root/backup-configs-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "📦 Salvando backups de /etc/rc.conf, /boot/loader.conf e /etc/fstab..."
cp /etc/rc.conf /etc/fstab /boot/loader.conf "$BACKUP_DIR" 2>/dev/null || true

# 3. Atualizar o sistema base e kernel
echo "⬇️  Atualizando sistema base e kernel..."
freebsd-update fetch
freebsd-update install || true

# 4. Atualizar repositórios de pacotes
echo "🧭 Atualizando repositórios pkg..."
pkg update -f

# 5. Atualizar todos os pacotes instalados
echo "⬆️  Atualizando pacotes instalados..."
pkg upgrade -y

# 6. Limpar pacotes antigos ou órfãos
echo "🧹 Limpando pacotes antigos..."
pkg autoremove -y
pkg clean -ay

# 7. Verificar se há reboot necessário
if [ -f /var/run/reboot_required ]; then
    echo "⚠️  Atualização requer reinicialização."
else
    echo "✅ Nenhuma reinicialização necessária."
fi

# 8. Exibir resumo
echo "=========================================="
echo " ✅ Atualização concluída com sucesso!"
echo " 📁 Backup salvo em: $BACKUP_DIR"
echo " 🕒 Finalizado em: $(date)"
echo "=========================================="
