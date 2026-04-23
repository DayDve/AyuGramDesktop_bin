#!/bin/bash
set -e

echo "=== Подготовка окружения (root) ==="
yum install -y ccache
# Гарантируем права для пользователя на папку кэша и исходники
mkdir -p /usr/src/tdesktop/.ccache
chown -R user:user /usr/src/tdesktop/.ccache
chown -R user:user /usr/src/tdesktop

echo "=== Запуск сборки (user) ==="
su user -c '
  export CCACHE_DIR=/usr/src/tdesktop/.ccache
  export CCACHE_MAXSIZE=10G
  export CCACHE_COMPRESS=1
  # Помогаем ccache дружить с Precompiled Headers
  export CCACHE_SLOPPINESS=pch_defines,time_macros

  echo "--- Статистика ccache до сборки ---"
  ccache -s

  /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
    -D TDESKTOP_API_ID=2040 \
    -D TDESKTOP_API_HASH=b18441a1ff607e10a989891a5462e627 \
    -D CMAKE_C_COMPILER_LAUNCHER=ccache \
    -D CMAKE_CXX_COMPILER_LAUNCHER=ccache

  echo "--- Статистика ccache после сборки ---"
  ccache -s
'

# Возвращаем права на папку кэша, чтобы GitHub Actions мог её прочитать
chown -R root:root /usr/src/tdesktop/.ccache