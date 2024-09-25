#!/bin/bash
mkdir -p AppDir/opt/wine-stable/
wget -q -c "https://github.com/lucasmz1/Wine-Builds2/releases/download/stable/wine-9.0-amd64.tar.xz"
tar xvf wine-9.0-amd64.tar.xz
mv wine-9.0-amd64/* ./AppDir/opt/wine-stable/
cp wrapper ./AppDir/
