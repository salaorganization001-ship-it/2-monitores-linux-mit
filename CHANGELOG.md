# Changelog

## [1.0.0] - 2024-10-18

### Adicionado
- Script principal `resolu_lightdm.sh` para configuração automática de resolução na tela de login
- Instalador automatizado `instalar_lightdm.sh`
- Detecção automática de monitores (HDMI, DisplayPort, VGA)
- Criação de modo de vídeo personalizado 1600x900_60.00
- Configuração de múltiplos monitores com posicionamento
- Sistema de priorização de monitores (DisplayPort > HDMI > VGA)
- Logs detalhados em `/tmp/resolu_lightdm.log`
- Suporte completo ao LightDM
- Documentação completa com exemplos e troubleshooting

### Características Técnicas
- Aguarda X server estar disponível antes de executar
- Aplica resolução personalizada em todos os monitores conectados
- Configura monitor primário automaticamente
- Posiciona monitores secundários à direita do primário
- Execução automática via hooks do LightDM

### Testado em
- Linux Mint 22 cinnamon

---

**Nota**: Este é o primeiro release estável do ResoluLightDM, resolvendo o problema de configuração de resolução na tela de login do Linux.
