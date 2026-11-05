# wine_appimage

<h1>wine 11 avaliable just donwload it!<h1/>
    * [Latest Stable Release](https://github.com/lucasmz1/wine_appimage/releases/tag/continuous-stable)
<br>if you face audio issues like audio craking or noise do this "export PULSE_LATENCY_MSEC=60", this is not a problem of my build, this is a well known wine issue.<br/>
<h1>enjoy<h1/>
<br>if you install dxvk you must override vulkan-1 WINEDLLOVERRIDES="vulkan-1=b" ./wine-x86_64.AppImage gta-vc.exe <br/>
<h1>All credits to Taqi Raza<h1/>
<h1>And Also Kron4ek<h1/>
<h3>Mangohud added, for call it just use the env var MANGOHUD=1 before the ./wine.appimage<h3/>
<h3> <br> New improvement now you can make symlink to the appimage like: `ln -rs ./wine.appimage wine` or `ln -rs ./wine.appimage winecfg` to any other wine binary also binaries placed inside of the appimage like vkcube etc. this was done aiming to make integration with lutris appimage, like make some symlinks to wine binaries and add then through the lutris gui to easily call wine when a game is launched<br/> <h3/>
