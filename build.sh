#!/usr/bin/env bash

set -Eeuo pipefail

# 可维护配置
readonly PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly RESOURCE_PACK_DIR="client-overrides/resourcepacks"

# 由 build.sh 手动注入整合包的 overrides 目录
# 预留 server-overrides：目录存在时自动打包，不存在时跳过
declare -ra OVERRIDE_DIRS=(
  "client-overrides"
  "server-overrides"
)

# 资源包列表：每行一个，格式为 "名称|GitHub Releases API 地址|资源包文件名正则"
# 新增资源包只需在此追加一行即可，无需改动其它逻辑
declare -ra RESOURCE_PACKS=(
  "汉化资源包|https://api.github.com/repos/alittlehuaji/Cinderworks-TranslatePack/releases/latest|^Cinderworks_TranslatePack\.zip$"
)

# 版本标签校验：pack.toml 中的 version 是唯一版本来源
# 每个文件都必须包含该版本号；v 前缀为可选（如 v1.2.0-beta.2 与 1.2.0-beta.2 均可）
declare -ra VERSION_TAG_FILES=(
  "client-overrides/config/customwindowtitle-client.toml"
)

OUTPUT_PATH=""
OUTPUT_ARCHIVE=""
TEMP_DIR=""

# 收集本次已下载并待嵌入的资源包文件名
declare -a EMBEDDED_PACK_NAMES=()

die() {
  echo "错误: $*" >&2
  exit 1
}

# 校验配置文件中使用的版本标签与 pack.toml 保持一致
check_version_tags() {
  local line pack_version="" expected_tag version_file file_content

  while IFS= read -r line; do
    if [[ "$line" =~ ^[[:space:]]*version[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
      pack_version="${BASH_REMATCH[1]}"
      break
    fi
  done < pack.toml

  [[ -n "$pack_version" ]] || die "无法从 pack.toml 读取 version 字段"

  # 直接校验版本号本身，兼容带 v 前缀与不带前缀两种写法
  expected_tag="$pack_version"

  for version_file in "${VERSION_TAG_FILES[@]}"; do
    [[ -f "$version_file" ]] || die "版本标签校验文件不存在: $version_file"
    file_content="$(< "$version_file")"
    [[ "$file_content" == *"$expected_tag"* ]] ||
      die "版本标签不一致: $version_file 中未找到 $expected_tag（来自 pack.toml）"
  done

  echo "版本标签校验通过: $expected_tag"
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

# 下载并校验单个资源包，成功后放入嵌入目录
# 参数: 名称 API地址 文件名正则
download_pack() {
  local name="$1" api="$2" pattern="$3"
  local release_data="$TEMP_DIR/release-${#EMBEDDED_PACK_NAMES[@]}.json"
  local asset_info download_url expected_digest asset_name pack_file
  local embed_dir="$TEMP_DIR/embed"

  curl --fail --location --retry 3 --silent --show-error \
    --header "Accept: application/vnd.github+json" \
    --header "X-GitHub-Api-Version: 2022-11-28" \
    --output "$release_data" \
    "$api"

  asset_info="$(jq --raw-output --exit-status \
    --arg pattern "$pattern" \
    'first(.assets[] | select(.name | test($pattern))) | [.name, .browser_download_url, .digest] | @tsv' \
    "$release_data")" || die "[$name] 最新正式 Release 中没有匹配的资源包"

  IFS=$'\t' read -r asset_name download_url expected_digest <<< "$asset_info"
  [[ "$expected_digest" == sha256:* ]] || die "[$name] 资源包没有有效的 SHA-256 摘要"
  expected_digest="${expected_digest#sha256:}"

  pack_file="$TEMP_DIR/$asset_name"
  curl --fail --location --retry 3 --silent --show-error \
    --output "$pack_file" \
    "$download_url"

  echo "$expected_digest  $pack_file" | sha256sum --check --status ||
    die "[$name] 资源包 SHA-256 校验失败"
  unzip -tq "$pack_file" >/dev/null || die "[$name] 资源包不是有效的 ZIP 文件"

  mkdir -p "$embed_dir/$RESOURCE_PACK_DIR"
  cp "$pack_file" "$embed_dir/$RESOURCE_PACK_DIR/$asset_name"
  EMBEDDED_PACK_NAMES+=("$asset_name")
}

# 遍历配置数组，逐个下载并校验所有资源包
download_all_packs() {
  local entry name api pattern
  for entry in "${RESOURCE_PACKS[@]}"; do
    IFS='|' read -r name api pattern <<< "$entry"
    [[ -n "$name" && -n "$api" && -n "$pattern" ]] ||
      die "资源包配置格式错误（应为 名称|API|正则）: $entry"
    echo "  · $name"
    download_pack "$name" "$api" "$pattern"
  done
}

# 将仓库的 overrides 目录与已下载的资源包写入整合包
# 仓库内 client-overrides/、server-overrides/ 以顶层路径写入（Modrinth 格式期望位置）
# 下载的资源包位于临时嵌入目录的 client-overrides/resourcepacks/ 下，同样以顶层路径写入
embed_overrides() {
  local embed_dir="$TEMP_DIR/embed"
  local dir

  # 仓库内已存在的 overrides 目录：在仓库根目录直接递归打包，保证顶层路径正确
  local has_repo_overrides=0
  for dir in "${OVERRIDE_DIRS[@]}"; do
    if [[ -d "$PROJECT_DIR/$dir" ]]; then
      zip -q -r "$OUTPUT_ARCHIVE" "$dir"
      has_repo_overrides=1
    fi
  done

  # 脚本下载的资源包：在嵌入目录打包，路径前缀同为 client-overrides/resourcepacks/
  if [[ -d "$embed_dir" && ${#EMBEDDED_PACK_NAMES[@]} -gt 0 ]]; then
    local archive_args=()
    local asset_name
    for asset_name in "${EMBEDDED_PACK_NAMES[@]}"; do
      archive_args+=("$RESOURCE_PACK_DIR/$asset_name")
    done
    (
      cd "$embed_dir"
      zip -q "$OUTPUT_ARCHIVE" "${archive_args[@]}"
    )
  fi

  [[ $has_repo_overrides -eq 1 || ${#EMBEDDED_PACK_NAMES[@]} -gt 0 ]] || return 0
}

main() {
  cd "$PROJECT_DIR"
  prepare_output "$@"
  check_requirements

  TEMP_DIR="$(mktemp -d)"
  trap 'rm -rf -- "$TEMP_DIR"' EXIT

  echo "[1/5] 校验版本标签"
  check_version_tags

  echo "[2/5] 检查 Packwiz 索引"
  refresh_index

  echo "[3/5] 导出 Modrinth 整合包"
  build_modpack

  echo "[4/5] 下载并校验资源包"
  download_all_packs

  echo "[5/5] 注入 overrides 与资源包"
  embed_overrides

  echo "已加入资源包: ${EMBEDDED_PACK_NAMES[*]:-无}"
  echo "构建完成: $OUTPUT_PATH"
}

main "$@"
