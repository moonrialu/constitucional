#!/usr/bin/env bash
# Instala o Flutter (quando necessário) e gera o build web no Netlify.
# A versão vem de FLUTTER_VERSION (definida em netlify.toml).
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.47.8}"
FLUTTER_HOME="${HOME}/.cache/flutter-${FLUTTER_VERSION}"
FLUTTER_ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_ARCHIVE}"

if [ ! -x "${FLUTTER_HOME}/bin/flutter" ]; then
  echo "==> Instalando Flutter ${FLUTTER_VERSION} em ${FLUTTER_HOME}"
  mkdir -p "$(dirname "${FLUTTER_HOME}")"
  curl -fsSL --retry 3 --retry-delay 5 -o "/tmp/${FLUTTER_ARCHIVE}" "${FLUTTER_URL}"
  rm -rf "${FLUTTER_HOME}.tmp"
  mkdir -p "${FLUTTER_HOME}.tmp"
  tar -xJf "/tmp/${FLUTTER_ARCHIVE}" -C "${FLUTTER_HOME}.tmp" --strip-components=1
  mv "${FLUTTER_HOME}.tmp" "${FLUTTER_HOME}"
  rm -f "/tmp/${FLUTTER_ARCHIVE}"
fi

export PATH="${FLUTTER_HOME}/bin:${PATH}"
export PUB_CACHE="${PUB_CACHE:-${HOME}/.cache/pub}"

flutter --version
flutter config --no-analytics >/dev/null

flutter pub get
flutter build web \
  --release \
  --pwa-strategy=none \
  --no-web-resources-cdn
