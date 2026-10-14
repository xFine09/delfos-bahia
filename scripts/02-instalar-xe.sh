#!/usr/bin/env bash
# =====================================================================
# 02-instalar-xe.sh — Instala Oracle Database 21c XE en Ubuntu (alien + dpkg)
# Ejecutar DENTRO DE LA VM como sercal, con el RPM en el directorio personal:
#   scp oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm sercal@delfos.inf:~/
# Antes: snapshot 's1-preparada-pre-oracle' y, si el disco es de 40 GB,
#        02-ampliar-disco-anfitrion.sh en el anfitrión.
# NO ejecutar después '/etc/init.d/oracle-xe-21c configure': BAHIA se crea con DBCA.
# =====================================================================
set -euo pipefail

RPM="$HOME/oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm"
RPM_SHA256="f8357b432de33478549a76557e8c5220ec243710ed86115c65b0c2bc00a848db"
DEB="$HOME/oracle-database-xe-21c_1.0-2_amd64.deb"

# Si Oracle ya está instalado, no seguir: el chown -R de abajo rompería oradism
if dpkg -s oracle-database-xe-21c >/dev/null 2>&1; then
  echo "oracle-database-xe-21c ya está instalado; nada que hacer."; exit 0
fi

# --- 1. Integridad del RPM --------------------------------------------
echo "$RPM_SHA256  $RPM" | sha256sum --check

# --- 2. Espacio: usar todo el VG y el disco ampliado (cabezazo 5) ------
sudo apt install -y cloud-guest-utils
sudo growpart /dev/vda 3 || true          # "NOCHANGE" si ya está crecida
sudo pvresize /dev/vda3
sudo lvextend -r -l +100%FREE /dev/ubuntu-vg/ubuntu-lv || true
df -h /
df -h /tmp                                 # tmpfs en RAM: no sirve para alien

# --- 3. RPM -> DEB con un TMPDIR en disco (cabezazo 6) -----------------
#     Los avisos NOKEY y los errores de dpkg-shlibdeps se pueden ignorar.
mkdir -p "$HOME/tmp-alien"
cd "$HOME"
sudo env TMPDIR="$HOME/tmp-alien" alien --scripts -d "$RPM"
ls -lh "$DEB"                              # debe pesar ~2,2 GB, no KB
sudo rm -rf "$HOME/tmp-alien" "$HOME/oracle-database-xe-21c-1.0"

# --- 4. Preparación previa al dpkg ------------------------------------
# libaio en Ubuntu 26.04 se llama libaio.so.1t64
sudo ln -sf /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1
# ¡NO crear ningún enlace para awk! (cabezazo 7: /bin es /usr/bin)
awk --version | head -1
# El preinst exige que ORACLE_BASE sea de oracle (cabezazo 8)
sudo chown -R oracle:oinstall /opt/oracle /opt/oraInventory

# --- 5. Instalación ---------------------------------------------------
sudo dpkg -i "$DEB"
# Desde aquí, NUNCA más chown -R sobre /opt/oracle (cabezazo 13: oradism)

# --- 6. Limpieza (los originales se guardan en software/ del anfitrión)
rm -f "$RPM"
sudo rm -f "$DEB"
df -h /

echo "Listo. Siguiente: snapshot 's2-xe-instalado' y 03-dbca-bahia.sh como oracle."
