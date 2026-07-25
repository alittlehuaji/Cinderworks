#!/usr/bin/env bash

set -Eeuo pipefail

# 可维护配置
readonly PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly TRANSLATE_PACK_API="https://api.github.com/repos/alittlehuaji/Cinderworks-TranslatePack/releases/latest"
readonly TRANSLATE_PACK_PATTERN='^Cinderworks_TranslatePack-.*\.zip$'
readonly RESOURCE_PACK_DIR="client-overrides/resourcepacks"

OUTPUT_PATH=""
OUTPUT_ARCHIVE=""
TEMP_DIR=""
TRANSLATE_PACK_NAME=""
TRANSLATE_PACK_FILE=""

die() {
  echo "错误: $*" >&2
  exit 1
}

check_requirements() {
  local item

  for item in pack.toml index.toml; do
    [[ -f "$item" ]] || die "缺少必要文件: $item"
  done

  for item in packwiz curl jq unzip zip sha256sum cmp; do
    command -v "$item" >/dev/null 2>&1 || die "未找到必要命令: $item"
  done
}

prepare_output() {
  (( $# == 1 )) || die "用法: $0 <输出文件.mrpack>"

  OUTPUT_PATH="$1"
  [[ "$OUTPUT_PATH" == *.mrpack ]] || die "输出文件必须使用 .mrpack 扩展名: $OUTPUT_PATH"

  if [[ "$OUTPUT_PATH" == /* ]]; then
    OUTPUT_ARCHIVE="$OUTPUT_PATH"
  else
    OUTPUT_ARCHIVE="$PROJECT_DIR/$OUTPUT_PATH"
  fi

  mkdir -p "$(dirname -- "$OUTPUT_ARCHIVE")"
  rm -f -- "$OUTPUT_ARCHIVE"
}

refresh_index() {
  cp pack.toml "$TEMP_DIR/pack.toml"
  cp index.toml "$TEMP_DIR/index.toml"

  packwiz refresh

  if ! cmp --silent pack.toml "$TEMP_DIR/pack.toml" ||
    ! cmp --silent index.toml "$TEMP_DIR/index.toml"; then
    die "Packwiz 索引已过期，请提交 packwiz refresh 产生的变更后重试"
  fi
}

build_modpack() {
  packwiz modrinth export --output "$OUTPUT_ARCHIVE"
  [[ -s "$OUTPUT_ARCHIVE" ]] || die "未生成有效产物: $OUTPUT_PATH"
}

download_translate_pack() {
  local release_data="$TEMP_DIR/translate-pack-release.json"
  local asset_info
  local download_url
  local expected_digest

  curl --fail --location --retry 3 --silent --show-error \
    --header "Accept: application/vnd.github+json" \
    --header "X-GitHub-Api-Version: 2022-11-28" \
    --output "$release_data" \
    "$TRANSLATE_PACK_API"

  asset_info="$(jq --raw-output --exit-status \
    --arg pattern "$TRANSLATE_PACK_PATTERN" \
    'first(.assets[] | select(.name | test($pattern))) | [.name, .browser_download_url, .digest] | @tsv' \
    "$release_data")" || die "最新正式 Release 中没有可用的汉化资源包"

  IFS=$'\t' read -r TRANSLATE_PACK_NAME download_url expected_digest <<< "$asset_info"
  [[ "$expected_digest" == sha256:* ]] || die "汉化资源包没有有效的 SHA-256 摘要"
  expected_digest="${expected_digest#sha256:}"

  TRANSLATE_PACK_FILE="$TEMP_DIR/$TRANSLATE_PACK_NAME"
  curl --fail --location --retry 3 --silent --show-error \
    --output "$TRANSLATE_PACK_FILE" \
    "$download_url"

  echo "$expected_digest  $TRANSLATE_PACK_FILE" | sha256sum --check --status ||
    die "汉化资源包 SHA-256 校验失败"
  unzip -tq "$TRANSLATE_PACK_FILE" >/dev/null || die "汉化资源包不是有效的 ZIP 文件"
}

add_translate_pack() {
  local embed_dir="$TEMP_DIR/embed"

  mkdir -p "$embed_dir/$RESOURCE_PACK_DIR"
  cp "$TRANSLATE_PACK_FILE" "$embed_dir/$RESOURCE_PACK_DIR/$TRANSLATE_PACK_NAME"

  (
    cd "$embed_dir"
    zip -q "$OUTPUT_ARCHIVE" "$RESOURCE_PACK_DIR/$TRANSLATE_PACK_NAME"
  )
}

main() {
  cd "$PROJECT_DIR"
  prepare_output "$@"
  check_requirements

  TEMP_DIR="$(mktemp -d)"
  trap 'rm -rf -- "$TEMP_DIR"' EXIT

  echo "[1/4] 检查 Packwiz 索引"
  refresh_index

  echo "[2/4] 导出 Modrinth 整合包"
  build_modpack

  echo "[3/4] 下载并校验汉化资源包"
  download_translate_pack

  echo "[4/4] 将汉化资源包加入整合包"
  add_translate_pack

  echo "已加入资源包: $TRANSLATE_PACK_NAME"
  echo "构建完成: $OUTPUT_PATH"
}

main "$@"
