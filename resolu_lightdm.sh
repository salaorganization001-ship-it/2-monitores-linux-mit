#!/bin/bash

# Script para configurar resolução na tela de seleção de usuário do LightDM
# Baseado no resolu.sh original

# Aguarda o X server estar disponível
export DISPLAY=:0

# Loop até o X server estar pronto
while ! xrandr >/dev/null 2>&1; do
    sleep 0.5
done

# Aguarda um pouco para garantir que tudo está carregado
sleep 1

# Detecta monitores conectados
HDMI_MONITOR=$(xrandr | grep "HDMI" | grep "connected" | grep -v "disconnected" | awk '{print $1}' | head -1)
DP_MONITOR=$(xrandr | grep "DP" | grep "connected" | grep -v "disconnected" | awk '{print $1}' | head -1)
VGA_MONITOR=$(xrandr | grep "VGA" | grep "connected" | grep -v "disconnected" | awk '{print $1}' | head -1)

# Conta quantos monitores estão conectados
MONITOR_COUNT=0
[ -n "$HDMI_MONITOR" ] && MONITOR_COUNT=$((MONITOR_COUNT + 1))
[ -n "$DP_MONITOR" ] && MONITOR_COUNT=$((MONITOR_COUNT + 1))
[ -n "$VGA_MONITOR" ] && MONITOR_COUNT=$((MONITOR_COUNT + 1))

if [ $MONITOR_COUNT -eq 0 ]; then
    echo "Erro: Nenhum monitor conectado encontrado!" >> /tmp/resolu_lightdm.log
    exit 1
fi

# Define monitor primário com prioridade: DisplayPort > HDMI > VGA
PRIMARY_MONITOR=""
if [ -n "$DP_MONITOR" ]; then
    PRIMARY_MONITOR="$DP_MONITOR"
    echo "Monitor DisplayPort detectado: $PRIMARY_MONITOR" >> /tmp/resolu_lightdm.log
elif [ -n "$HDMI_MONITOR" ]; then
    PRIMARY_MONITOR="$HDMI_MONITOR"
    echo "Monitor HDMI detectado: $PRIMARY_MONITOR" >> /tmp/resolu_lightdm.log
elif [ -n "$VGA_MONITOR" ]; then
    PRIMARY_MONITOR="$VGA_MONITOR"
    echo "Monitor VGA detectado: $PRIMARY_MONITOR" >> /tmp/resolu_lightdm.log
fi

echo "Total de monitores conectados: $MONITOR_COUNT" >> /tmp/resolu_lightdm.log

# Verifica se o modo já existe
if ! xrandr | grep -q "1600x900_60.00"; then
    echo "Criando novo modo de vídeo 1600x900_60.00..." >> /tmp/resolu_lightdm.log
    xrandr --newmode "1600x900_60.00"  118.25  1600 1696 1856 2112  900 903 908 934 -hsync +vsync
    
    # Adiciona o modo para todos os monitores conectados
    [ -n "$VGA_MONITOR" ] && xrandr --addmode $VGA_MONITOR 1600x900_60.00
    [ -n "$HDMI_MONITOR" ] && xrandr --addmode $HDMI_MONITOR 1600x900_60.00
    [ -n "$DP_MONITOR" ] && xrandr --addmode $DP_MONITOR 1600x900_60.00
else
    echo "Modo 1600x900_60.00 já existe." >> /tmp/resolu_lightdm.log
fi

# Aplica a resolução personalizada nos monitores
if [ -n "$VGA_MONITOR" ]; then
    echo "Alterando VGA para resolução 1600x900..." >> /tmp/resolu_lightdm.log
    xrandr --output $VGA_MONITOR --mode 1600x900_60.00
fi

# Se o monitor primário for HDMI, também aplica a resolução personalizada
if [ -n "$HDMI_MONITOR" ] && [ "$PRIMARY_MONITOR" == "$HDMI_MONITOR" ]; then
    echo "Alterando HDMI primário para resolução 1600x900..." >> /tmp/resolu_lightdm.log
    xrandr --output $HDMI_MONITOR --mode 1600x900_60.00
fi

# Se o monitor primário for DisplayPort, também aplica a resolução personalizada
if [ -n "$DP_MONITOR" ] && [ "$PRIMARY_MONITOR" == "$DP_MONITOR" ]; then
    echo "Alterando DisplayPort primário para resolução 1600x900..." >> /tmp/resolu_lightdm.log
    xrandr --output $DP_MONITOR --mode 1600x900_60.00
fi

# Se há múltiplos monitores, configura posicionamento
if [ $MONITOR_COUNT -gt 1 ]; then
    echo "Configurando múltiplos monitores..." >> /tmp/resolu_lightdm.log
    echo "Definindo $PRIMARY_MONITOR como monitor primário..." >> /tmp/resolu_lightdm.log
    xrandr --output $PRIMARY_MONITOR --primary
    
    # Posiciona os monitores secundários à direita do primário
    if [ -n "$HDMI_MONITOR" ] && [ "$HDMI_MONITOR" != "$PRIMARY_MONITOR" ]; then
        echo "Posicionando HDMI à direita do monitor primário..." >> /tmp/resolu_lightdm.log
        xrandr --output $HDMI_MONITOR --right-of $PRIMARY_MONITOR
    fi
    
    if [ -n "$VGA_MONITOR" ] && [ "$VGA_MONITOR" != "$PRIMARY_MONITOR" ]; then
        echo "Posicionando VGA à direita do monitor primário..." >> /tmp/resolu_lightdm.log
        xrandr --output $VGA_MONITOR --right-of $PRIMARY_MONITOR
    fi
    
    if [ -n "$DP_MONITOR" ] && [ "$DP_MONITOR" != "$PRIMARY_MONITOR" ]; then
        echo "Posicionando DisplayPort à direita do monitor primário..." >> /tmp/resolu_lightdm.log
        xrandr --output $DP_MONITOR --right-of $PRIMARY_MONITOR
    fi
else
    echo "Apenas um monitor detectado. Apenas otimizando resolução..." >> /tmp/resolu_lightdm.log
    echo "Definindo $PRIMARY_MONITOR como monitor primário..." >> /tmp/resolu_lightdm.log
    xrandr --output $PRIMARY_MONITOR --primary
fi

echo "Configuração de resolução aplicada na tela do LightDM!" >> /tmp/resolu_lightdm.log
