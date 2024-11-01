#!/bin/bash
     WINE_VER="$(wget -qO- https://dl.winehq.org/wine-builds/ubuntu/dists/focal/main/binary-amd64/ | grep wine-stable | sed 's|_| |g;s|~| |g' | awk '{print $5}' | tail -n1)"
     wget -q -c https://dl.winehq.org/wine-builds/ubuntu/dists/focal/main/binary-i386/wine-stable_9.0.0.0~focal-1_i386.deb
     wget -q -c https://dl.winehq.org/wine-builds/ubuntu/dists/focal/main/binary-i386/wine-stable-i386_9.0.0.0~focal-1_i386.deb
     wget -q -c https://dl.winehq.org/wine-builds/ubuntu/dists/focal/main/binary-amd64/wine-stable_9.0.0.0~focal-1_amd64.deb
     wget -q -c https://dl.winehq.org/wine-builds/ubuntu/dists/focal/main/binary-amd64/wine-stable-amd64_9.0.0.0~focal-1_amd64.deb
     dpkg -x "wine-stable_9.0.0.0~focal-1_i386.deb" AppDir/
     dpkg -x "wine-stable-i386_9.0.0.0~focal-1_i386.deb" AppDir/
     dpkg -x "wine-stable_9.0.0.0~focal-1_amd64.deb" AppDir/
     dpkg -x "wine-stable-amd64_9.0.0.0~focal-1_amd64.deb" AppDir/
     ln -rsf ./AppDIr/runtime/compat/lib/i386-linux-gnu/ld-linux.so.2 ./AppDir/runtime/default/lib/
     patchelf --set-interpreter 'lib/ld-linux.so.2' ./AppDir/opt/wine-stable/bin/wine
     (cd AppDir/usr/bin; ln -s "../../opt/wine-stable/bin/"* .)

     # Cleanup
     rm -rf AppDir/usr/share/{applications,man,doc}
     rm -rf AppDir/opt/wine-stable/share/{applications,man,doc}

     # Disable FileOpenAssociations
     sed -i 's|    LicenseInformation|    LicenseInformation,\\\n    FileOpenAssociations|g;$a \\n[FileOpenAssociations]\nHKCU,Software\\Wine\\FileOpenAssociations,"Enable",,"N"' AppDir/opt/wine-stable/share/wine/wine.inf

     # Disable winemenubuilder
     sed -i 's|    FileOpenAssociations|    FileOpenAssociations,\\\n    DllOverrides|;$a \\n[DllOverrides]\nHKCU,Software\\Wine\\DllOverrides,"*winemenubuilder.exe",,""' AppDir/opt/wine-stable/share/wine/wine.inf
     sed -i '/\%11\%\\winemenubuilder.exe -a -r/d' AppDir/opt/wine-stable/share/wine/wine.inf

     # Pre patch setting wine blue theme by default
     sed -i 's|    DllOverrides|    DllOverrides,\\\n    ThemeSet|;$a \\n[ThemeSet]\nHKCU,Software\\Microsoft\\Windows\\CurrentVersion\\ThemeManager,"ColorName",,"Blue"\nHKCU,Software\\Microsoft\\Windows\\CurrentVersion\\ThemeManager,"DllName",,"C:\\windows\\Resources\\Themes\\light\\light.msstyles"\nHKCU,Software\\Microsoft\\Windows\\CurrentVersion\\ThemeManager,"ThemeActive",,"1"' AppDir/opt/wine-stable/share/wine/wine.inf

     # Deploy wine-mono wine-gecko
     # For future reference setting of MONO_VER see https://github.com/wine-mirror/wine/tree/stable of wine-stable
     MONO_VER=$(wget "https://source.winehq.org/source/dlls/appwiz.cpl/addons.c?%21v=wine-9.0.0.0" -qO- | grep -Po 'MONO_VERSION</a>.*[0-9]"' | cut -d'"' -f4)
     GECKO_VER=$(wget "https://source.winehq.org/source/dlls/appwiz.cpl/addons.c?%21v=wine-9.0.0.0" -qO- | grep -Po 'GECKO_VERSION</a>.*[0-9]"' | cut -d'"' -f4)

     case "$WINE_VER" in
     3.0.1|3.0.2|3.0.3|3.0.4|3.0.5)
       GECKO_VER="2.47"
       MONO_VER="4.7.1"
       ;;

     4.0.1|4.0.2|4.0.3|4.0.4)
       GECKO_VER="2.47"
       MONO_VER="4.7.5"
       ;;

     5.0.1|5.0.2|5.0.3|5.0.4|5.0.5)
       GECKO_VER="2.47.1"
       MONO_VER="4.9.4"
       ;;

     6.0.1|6.0.2|6.0.3|6.0.4)
       GECKO_VER="2.47.2"
       MONO_VER="5.1.1"
       ;;

     7.0.1|7.0.2|7.0.3|7.0.4)
       GECKO_VER="2.47.2"
       MONO_VER="7.0.0-x86"
       ;;
       
     *)
       MONO_VER="$MONO_VER-x86"
       ;;
     esac

     if [[ $(echo $GECKO_VER |sed -e 's/\.//g') -le 247 ]]; then
        GECKO=wine_gecko-${GECKO_VER}
     else
        GECKO=wine-gecko-${GECKO_VER}
     fi

     MONO_URL="https://dl.winehq.org/wine/wine-mono/$(cut -d'-' -f1 <<< ${MONO_VER})/wine-mono-${MONO_VER}.msi"
     GECKO_URL_x86="https://dl.winehq.org/wine/wine-gecko/$GECKO_VER/${GECKO}-x86.msi"
     GECKO_URL_x86_64="https://dl.winehq.org/wine/wine-gecko/$GECKO_VER/${GECKO}-x86_64.msi"

     wget -q "$MONO_URL" -O AppDir/winedata/wine-mono-${MONO_VER}.msi
     wget -q "$GECKO_URL_x86" -O AppDir/winedata/${GECKO}-x86.msi
     wget -q "$GECKO_URL_x86_64" -O AppDir/winedata/${GECKO}-x86_64.msi
