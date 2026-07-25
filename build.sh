#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if (( $# != 1 )); then
  echo "用法: $0 <输出文件.mrpack>" >&2
  exit 2
fi

readonly OUTPUT_PATH="$1"
readonly TRANSLATE_PACK_API="https://api.github.com/repos/alittlehuaji/Cinderworks-TranslatePack/releases/latest"

if [[ "$OUTPUT_PATH" == /* ]]; then
  readonly OUTPUT_ARCHIVE="$OUTPUT_PATH"
else
  readonly OUTPUT_ARCHIVE="$SCRIPT_DIR/$OUTPUT_PATH"
fi

if [[ "$OUTPUT_PATH" != *.mrpack ]]; then
  echo "输出文件必须使用 .mrpack 扩展名: $OUTPUT_PATH" >&2
  exit 2
fi

for required_file in pack.toml index.toml; do
  if [[ ! -f "$required_file" ]]; then
    echo "缺少必要文件: $required_file" >&2
    exit 1
  fi
done

for required_command in packwiz curl unzip zip sha256sum; do
  if ! command -v "$required_command" >/dev/null 2>&1; then
    echo "未找到必要命令: $required_command" >&2
    exit 1
  fi
done

mkdir -p "$(dirname -- "$OUTPUT_PATH")"
rm -f -- "$OUTPUT_PATH"

readonly PACK_HASH_BEFORE="$(sha256sum pack.toml | cut -d ' ' -f 1)"
readonly INDEX_HASH_BEFORE="$(sha256sum index.toml | cut -d ' ' -f 1)"

packwiz refresh

readonly PACK_HASH_AFTER="$(sha256sum pack.toml | cut -d ' ' -f 1)"
readonly INDEX_HASH_AFTER="$(sha256sum index.toml | cut -d ' ' -f 1)"

if [[ "$PACK_HASH_BEFORE" != "$PACK_HASH_AFTER" || "$INDEX_HASH_BEFORE" != "$INDEX_HASH_AFTER" ]]; then
  echo "Packwiz 索引已过期，请提交 packwiz refresh 产生的变更后重试" >&2
  exit 1
fi

packwiz modrinth export --output "$OUTPUT_PATH"

if [[ ! -s "$OUTPUT_PATH" ]]; then
  echo "构建失败，未生成有效产物: $OUTPUT_PATH" >&2
  exit 1
fi

readonly TEMP_DIR="$(mktemp -d)"
trap 'rm -rf -- "$TEMP_DIR"' EXIT

readonly RELEASE_DATA="$TEMP_DIR/translate-pack-release.json"
curl --fail --location --retry 3 --silent --show-error \
  --header "Accept: application/vnd.github+json" \
  --header "X-GitHub-Api-Version: 2022-11-28" \
  --output "$RELEASE_DATA" \
  "$TRANSLATE_PACK_API"

readonly TRANSLATE_PACK_NAME="$(grep -oE '"name"[[:space:]]*:[[:space:]]*"Cinderworks_TranslatePack-[^"]+\.zip"' "$RELEASE_DATA" | head -n 1 | cut -d '"' -f 4)"
readonly TRANSLATE_PACK_URL="$(grep -oE '"browser_download_url"[[:space:]]*:[[:space:]]*"[^"]+/Cinderworks_TranslatePack-[^"]+\.zip"' "$RELEASE_DATA" | head -n 1 | cut -d '"' -f 4)"
readonly TRANSLATE_PACK_DIGEST="$(grep -oE '"digest"[[:space:]]*:[[:space:]]*"sha256:[0-9a-fA-F]{64}"' "$RELEASE_DATA" | head -n 1 | cut -d ':' -f 3 | tr -d '"')"

if [[ -z "$TRANSLATE_PACK_NAME" || -z "$TRANSLATE_PACK_URL" || -z "$TRANSLATE_PACK_DIGEST" ]]; then
  echo "无法读取汉化资源包附件的名称、下载地址或 SHA-256" >&2
  exit 1
fi

readonly TRANSLATE_PACK_FILE="$TEMP_DIR/$TRANSLATE_PACK_NAME"
curl --fail --location --retry 3 --silent --show-error \
  --output "$TRANSLATE_PACK_FILE" \
  "$TRANSLATE_PACK_URL"

echo "$TRANSLATE_PACK_DIGEST  $TRANSLATE_PACK_FILE" | sha256sum --check --status
unzip -tq "$TRANSLATE_PACK_FILE" >/dev/null

mkdir -p "$TEMP_DIR/client-overrides/resourcepacks"
cp -- "$TRANSLATE_PACK_FILE" "$TEMP_DIR/client-overrides/resourcepacks/$TRANSLATE_PACK_NAME"
(
  cd "$TEMP_DIR"
  zip -q "$OUTPUT_ARCHIVE" "client-overrides/resourcepacks/$TRANSLATE_PACK_NAME"
)

echo "已加入资源包: $TRANSLATE_PACK_NAME"

echo "构建完成: $OUTPUT_PATH"
