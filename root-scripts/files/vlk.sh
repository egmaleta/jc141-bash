#!/bin/bash
extract() { tar -xvf "$1" &>/dev/null; }; download() { command -v curl >/dev/null 2>&1 && curl -LO "$1"; }
SYSDXVK="$(command -v setup_dxvk)"; SYSVKD3D="$(command -v setup_vkd3d_proton)"
DXVK_URL="$(curl -s https://api.github.com/repos/jc141x/dxvk/releases/latest | awk -F '["]' '/"browser_download_url":/ {print $4}')"; DXVK="$(basename "$DXVK_URL")"
VKD_URL="$(curl -s https://api.github.com/repos/jc141x/vkd3d-proton/releases/latest | awk -F '["]' '/"browser_download_url":/ {print $4}')"; VKD3D="$(basename "$VKD_URL")";

[ -n "$SYSDXVK" ] && echo "using dxvk from system" && "$SYSDXVK" install && wineserver -w
[ -z "$SYSDXVK" ] && echo "using external dxvk" && [ ! -f "$DXVK" ] && download "$DXVK_URL"; extract "$DXVK" || { rm "$DXVK" && echo "failed to extract dxvk" && return 1; } && cd "${DXVK//.tar.gz/}" || exit; ./setup_dxvk.sh install && wineserver -w; cd "$OLDPWD" || exit; rm -rf "${DXVK//.tar.gz/}";

[ -n "$SYSVKD3D" ] && echo "using vkd3d from system" && "$SYSVKD3D" install && wineserver -w
[ -z "$SYSVKD3D" ] && echo "using external vkd3d" && [ ! -f "$VKD3D" ] && download "$VKD_URL"; extract "$VKD3D" || { rm "$VKD3D" && echo "failed to extract vkd3d" && return 1; } && cd "${VKD3D//.tar.zst/}" || exit; ./setup_vkd3d_proton.sh install && wineserver -w; cd "$OLDPWD" || exit; rm -rf "${VKD3D//.tar.zst/}";
