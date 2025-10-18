# ResoluLightDM

**Configura resolução personalizada na tela de login do LightDM automaticamente.**

## ✅ Verificar Requisitos

Antes de instalar, verifique:

```bash
# 1. Verifica se tem LightDM:
systemctl status lightdm

# 2. Verifica se tem xrandr:
xrandr --version

# 3. Verifica monitores conectados:
xrandr | grep connected

# 4. Verifica se tem sudo:
sudo -v
```

## 🚀 Instalação Passo a Passo

### 1. Baixar os arquivos
```bash
# Clone ou baixe os arquivos para uma pasta
```

### 2. Executar instalador
```bash
sudo ./instalar_lightdm.sh
```

### 3. Testar imediatamente
```bash
# Testa o script:
sudo /usr/local/bin/resolu_lightdm.sh

# Verifica se funcionou:
cat /tmp/resolu_lightdm.log
```

### 4. Testar na tela de login
```bash
# Reinicia o LightDM:
sudo systemctl restart lightdm
```

### 5. Verificar resultado
- Faça logout ou reinicie o sistema
- A tela de login deve aparecer com a resolução correta

## ✅ Como saber se funcionou

### Logs esperados:
```bash
cat /tmp/resolu_lightdm.log
```
Deve mostrar algo como:
```
Monitor HDMI detectado: HDMI-1
Total de monitores conectados: 2
Modo 1600x900_60.00 já existe.
Alterando VGA para resolução 1600x900...
Alterando HDMI primário para resolução 1600x900...
Configurando múltiplos monitores...
Definindo HDMI-1 como monitor primário...
Posicionando VGA à direita do monitor primário...
Configuração de resolução aplicada na tela do LightDM!
```

### Verificação visual:
- Tela de login com resolução 1600x900
- Elementos bem posicionados
- Múltiplos monitores configurados corretamente

## 📊 O que faz

- Detecta monitores conectados (HDMI, DisplayPort, VGA)
- Cria modo de vídeo 1600x900_60.00 se não existir
- Aplica resolução em todos os monitores
- Configura múltiplos monitores (primário + secundários à direita)
- Prioridade: DisplayPort > HDMI > VGA

## 📁 Arquivos

- `resolu_lightdm.sh` - Script principal
- `instalar_lightdm.sh` - Instalador
- `resolu.sh` - Script original (referência)

## 🔧 Instalação Manual

```bash
# 1. Copia o script
sudo cp resolu_lightdm.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/resolu_lightdm.sh

# 2. Configura o LightDM
sudo mkdir -p /etc/lightdm
echo "[SeatDefaults]" | sudo tee -a /etc/lightdm/lightdm.conf
echo "display-setup-script=/usr/local/bin/resolu_lightdm.sh" | sudo tee -a /etc/lightdm/lightdm.conf
```

## 📋 Verificar se funcionou

```bash
# Ver logs:
cat /tmp/resolu_lightdm.log

# Ver resolução atual:
xrandr | grep "1600x900"
```

## 🛠️ Personalizar

### Alterar Resolução
Edite `/usr/local/bin/resolu_lightdm.sh` linha 50-52:
```bash
xrandr --newmode "1600x900_60.00"  118.25  1600 1696 1856 2112  900 903 908 934 -hsync +vsync
```

### Alterar Prioridade de Monitores
Linhas 21-30 do script:
```bash
if [ -n "$DP_MONITOR" ]; then
    PRIMARY_MONITOR="$DP_MONITOR"
elif [ -n "$HDMI_MONITOR" ]; then
    PRIMARY_MONITOR="$HDMI_MONITOR"
elif [ -n "$VGA_MONITOR" ]; then
    PRIMARY_MONITOR="$VGA_MONITOR"
fi
```

## 🐛 Problemas Comuns e Soluções

### ❌ "Arquivo não encontrado" ao executar instalador
```bash
# Verifica se está na pasta correta:
ls -la instalar_lightdm.sh

# Se não estiver, navegue para a pasta:
cd /caminho/para/arquivos
```

### ❌ "Permissão negada" 
```bash
# Dá permissão de execução:
chmod +x instalar_lightdm.sh
chmod +x resolu_lightdm.sh
```

### ❌ "grep: /etc/lightdm/lightdm.conf: Arquivo ou diretório inexistente"
**Isso é normal!** O instalador cria o arquivo automaticamente.

### ❌ Script não executa após instalação
```bash
# Verifica se foi instalado:
ls -la /usr/local/bin/resolu_lightdm.sh

# Verifica configuração do LightDM:
cat /etc/lightdm/lightdm.conf
```

### ❌ Resolução não aplica
```bash
# Verifica logs:
cat /tmp/resolu_lightdm.log

# Testa manualmente:
sudo /usr/local/bin/resolu_lightdm.sh

# Verifica monitores conectados:
xrandr | grep connected
```

### ❌ "Nenhum monitor conectado encontrado"
```bash
# Verifica conexões:
xrandr

# Verifica se monitores estão ligados e conectados
# Reinicia o script:
sudo /usr/local/bin/resolu_lightdm.sh
```

### ❌ Tela de login não muda após reiniciar LightDM
```bash
# Verifica se o LightDM está rodando:
systemctl status lightdm

# Reinicia completamente:
sudo systemctl restart lightdm

# Ou reinicia o sistema:
sudo reboot
```

### ❌ "Modo de vídeo não suportado"
```bash
# Verifica modos disponíveis:
xrandr

# Testa com resolução diferente editando o script
# Ou usa resolução nativa do monitor
```

## 🗑️ Desinstalar

```bash
sudo sed -i '/display-setup-script/d' /etc/lightdm/lightdm.conf
sudo rm /usr/local/bin/resolu_lightdm.sh
sudo systemctl restart lightdm
```

## 📋 Requisitos

- Linux com LightDM
- sudo/root
- xrandr, bash

## 📄 Licença

MIT License
