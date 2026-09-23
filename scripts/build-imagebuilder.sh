#!/usr/bin/env bash
set -euo pipefail

# 中文注释：由工作流传入架构、版本及官方压缩包架构名。
TARGET="${TARGET:?TARGET is required}"
ARCHIVE_TARGET="${ARCHIVE_TARGET:?ARCHIVE_TARGET is required}"
OPENWRT_VERSION="${OPENWRT_VERSION:-23.05.5}"
EXTRA_PACKAGES="${EXTRA_PACKAGES:-}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAME="${TARGET////_}"
WORK_DIR="$ROOT_DIR/.work/$NAME"
OUT_DIR="$ROOT_DIR/artifacts/$NAME"
BASE_URL="https://downloads.openwrt.org/releases/$OPENWRT_VERSION/targets/$TARGET"
ARCHIVE="openwrt-imagebuilder-$OPENWRT_VERSION-$ARCHIVE_TARGET.Linux-x86_64.tar.xz"

rm -rf "$WORK_DIR" "$OUT_DIR"
mkdir -p "$WORK_DIR" "$OUT_DIR"
curl --fail --location --retry 3 "$BASE_URL/$ARCHIVE" --output "$WORK_DIR/$ARCHIVE"
tar -xJf "$WORK_DIR/$ARCHIVE" -C "$WORK_DIR"
IMAGE_BUILDER="$(find "$WORK_DIR" -mindepth 1 -maxdepth 1 -type d -name 'openwrt-imagebuilder-*' -print -quit)"
test -n "$IMAGE_BUILDER"

# 中文注释：逐行读取基础包，允许文件中保留空行和注释。
PACKAGES="$(sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$ROOT_DIR/config/packages.txt" | tr '\n' ' ') $EXTRA_PACKAGES"
make -C "$IMAGE_BUILDER" image PROFILE=generic PACKAGES="$PACKAGES" BIN_DIR="$OUT_DIR"

# 中文注释：为下载后的固件生成完整性校验文件。
(cd "$OUT_DIR" && sha256sum ./* > SHA256SUMS)
