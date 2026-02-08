#!/bin/bash
set -e
node app/scripts/generate.settings.mjs
curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 10.0
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$DOTNET_ROOT:$PATH
dotnet publish app/BlazorTemplate.csproj -c Release -o dist -p:BlazorEnableCompression=false
cp -R dist/wwwroot/* dist/
# usa o dotnet.js processado (com config embutida)
mkdir -p dist/_framework
DOTNET_JS_PATH="$(find dist/_framework -maxdepth 1 -name 'dotnet.*.js' ! -name 'dotnet.js' ! -name 'dotnet.*.*.js' | head -n 1 || true)"
if [ -z "$DOTNET_JS_PATH" ]; then
  DOTNET_JS_PATH="$(find app/obj -path '*Release*' -name dotnet.js | head -n 1 || true)"
fi
if [ -n "$DOTNET_JS_PATH" ] && [ -f "$DOTNET_JS_PATH" ]; then
  cp "$DOTNET_JS_PATH" dist/_framework/dotnet.js
  cp "$DOTNET_JS_PATH" dist/dotnet.js
else
  echo "ERRO: dotnet.js processado não encontrado (dist/_framework ou app/obj)"
  exit 1
fi
