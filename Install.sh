#!/bin/bash
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# INSTALADOR AUTOMÁTICO - Script Argentina
# Repositorio: https://github.com/kriito212/Script-argentina.git
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Colores
cyan="\033[1;36m"    # Cyan
green="\033[1;92m"   # Verde
red="\033[1;91m"     # Rojo
reset="\033[0m"      # Reset

# Configuración
REPO="https://github.com/kriito212/Script-argentina.git"
DIR_INSTALACION="/etc/script_argentina"

# Verificar root
if [[ $EUID -ne 0 ]]; then
  echo -e "${red}[ERROR] Ejecuta este script como root.${reset}"
  exit 1
fi

# Paso 1: Instalar dependencias
echo -e "${cyan}[*] Instalando dependencias...${reset}"
apt-get update && apt-get install -y \
  git wget curl openssl sed grep cron nano lsof \
  openssh-server dropbear stunnel4 squid python3 || {
  echo -e "${red}[ERROR] Falló la instalación de dependencias.${reset}"
  exit 1
}

# Paso 2: Clonar repositorio
echo -e "${cyan}[*] Clonando repositorio...${reset}"
rm -rf "$DIR_INSTALACION" 2>/dev/null
git clone "$REPO" "$DIR_INSTALACION" || {
  echo -e "${red}[ERROR] No se pudo clonar el repositorio.${reset}"
  exit 1
}

# Paso 3: Configurar permisos y enlaces
echo -e "${cyan}[*] Configurando accesos...${reset}"
chmod +x "$DIR_INSTALACION"/*.sh
ln -sf "$DIR_INSTALACION/menu_principal.sh" "/usr/local/bin/script-arg"
ln -sf "$DIR_INSTALACION/keygen.sh" "/usr/local/bin/script-arg-keygen"

# Paso 4: Crear base de datos de licencias
touch "$DIR_INSTALACION/licencias.db"
chmod 600 "$DIR_INSTALACION/licencias.db"

# Mensaje final
echo -e "${green}
╔════════════════════════════════════════╗
║   INSTALACIÓN COMPLETADA CON ÉXITO!    ║
╚════════════════════════════════════════╝${reset}

Comandos disponibles:
- Menú principal: ${cyan}script-arg${reset}
- Generar licencias: ${cyan}script-arg-keygen${reset}
"
