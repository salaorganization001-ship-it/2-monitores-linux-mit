#!/bin/bash

echo "=== Instalador Resolu LightDM ==="
echo ""

# Verifica se está rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "Execute como root: sudo ./instalar_lightdm.sh"
    exit 1
fi

# Copia o script para /usr/local/bin
echo "Instalando script..."
cp /home/vanir/Público/resolu_lightdm.sh /usr/local/bin/
chmod +x /usr/local/bin/resolu_lightdm.sh

# Configura o LightDM para executar o script
echo "Configurando LightDM..."

# Backup do arquivo original
if [ -f /etc/lightdm/lightdm.conf ]; then
    cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.backup
fi

# Adiciona configuração se não existir
if ! grep -q "display-setup-script" /etc/lightdm/lightdm.conf; then
    echo "" >> /etc/lightdm/lightdm.conf
    echo "[SeatDefaults]" >> /etc/lightdm/lightdm.conf
    echo "display-setup-script=/usr/local/bin/resolu_lightdm.sh" >> /etc/lightdm/lightdm.conf
    echo "Configuração adicionada ao LightDM!"
else
    echo "Configuração já existe no LightDM!"
fi

echo ""
echo "=== Instalado! ==="
echo ""
echo "✅ Script configurado para rodar na tela do LightDM"
echo ""
echo "Para testar:"
echo "1. sudo /usr/local/bin/resolu_lightdm.sh"
echo "2. sudo systemctl restart lightdm"
echo ""
echo "Para ver logs: cat /tmp/resolu_lightdm.log"
echo ""
echo "🔄 A resolução será aplicada automaticamente na tela de seleção de usuário!"
