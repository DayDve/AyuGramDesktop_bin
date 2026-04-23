#!/bin/bash
set -e

echo "=== Подготовка окружения (root) ==="
yum install -y ccache
chown -R user:user /usr/src/tdesktop

echo "=== Запуск сборки (user) ==="
su user -c '
  export CCACHE_DIR=/home/user/.ccache
  export CCACHE_MAXSIZE=2G

  /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
    -D TDESKTOP_API_ID=2040 \
    -D TDESKTOP_API_HASH=b18441a1ff607e10a989891a5462e627 \
    -D CMAKE_C_COMPILER_LAUNCHER=ccache \
    -D CMAKE_CXX_COMPILER_LAUNCHER=ccache

  echo "=== Статистика ccache ==="
  ccache -s
'