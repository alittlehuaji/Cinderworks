#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

# 发布配置
readonly PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly PACK_FILE="pack.toml"
readonly INDEX_FILE="index.toml"
readonly WINDOW_TITLE_FILE="client-overrides/config/customwindowtitle-client.toml"
readonly BUILD_SCRIPT="build.sh"
readonly RELEASE_REMOTE="origin"
readonly TOTAL_STEPS=10
readonly SEMVER_REGEX='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-([0-9A-Za-z-]+)(\.[0-9A-Za-z-]+)*)?(\+([0-9A-Za-z-]+)(\.[0-9A-Za-z-]+)*)?$'

declare -ra RELEASE_FILES=(
  "$PACK_FILE"
  "$INDEX_FILE"
  "$WINDOW_TITLE_FILE"
)

CURRENT_STEP="初始化"
CURRENT_BRANCH=""
PACK_VERSION=""
EXPECTED_PACK_VERSION=""
WINDOW_TITLE_VERSION=""
TAG_NAME=""
RELEASE_COMMIT=""
TEMP_DIR=""
SYNC_TEMP_FILE=""
PUSH_RELEASE=false
STEP_NUMBER=0

die() {
  printf '错误 [%s]: %s\n' "$CURRENT_STEP" "$*" >&2
  exit 1
}

on_error() {
  local exit_code="$1"
  local line_number="$2"
  local command="$3"

  trap - ERR
  printf '发布失败\n' >&2
  printf '  阶段: %s\n' "$CURRENT_STEP" >&2
  printf '  行号: %s\n' "$line_number" >&2
  printf '  命令: %s\n' "$command" >&2
  printf '  状态码: %s\n' "$exit_code" >&2
  printf '已生成的版本文件改动不会被自动删除，可修复问题后重新执行脚本\n' >&2
  exit "$exit_code"
}

cleanup() {
  local exit_code="$?"

  trap - EXIT
  if [[ -n "$SYNC_TEMP_FILE" ]]; then
    rm -f -- "$SYNC_TEMP_FILE" || true
  fi
  if [[ -n "$TEMP_DIR" ]]; then
    rm -rf -- "$TEMP_DIR" || true
  fi
  exit "$exit_code"
}

trap 'on_error "$?" "$LINENO" "$BASH_COMMAND"' ERR
trap cleanup EXIT

usage() {
  cat <<'EOF'
用法: ./release.sh [--push]

从 pack.toml 读取版本，更新窗口标题，验证构建并创建本地发布提交与标签

选项:
  --push     创建提交与标签后，原子推送当前分支和标签到 origin
  -h, --help 显示帮助
EOF
}

parse_arguments() {
  while (( $# > 0 )); do
    case "$1" in
      --push)
        PUSH_RELEASE=true
        ;;
      -h | --help)
        usage
        exit 0
        ;;
      *)
        usage >&2
        die "未知参数: $1"
        ;;
    esac
    shift
  done
}

start_step() {
  CURRENT_STEP="$1"
  ((STEP_NUMBER += 1))
  printf '\n[%d/%d] %s\n' "$STEP_NUMBER" "$TOTAL_STEPS" "$CURRENT_STEP"
}

initialize() {
  cd "$PROJECT_DIR"
  TEMP_DIR="$(mktemp -d)"
}

check_requirements() {
  local command

  for command in bash git packwiz sed mktemp chmod mv; do
    command -v "$command" >/dev/null 2>&1 || die "未找到必要命令: $command"
  done

  [[ -f "$PACK_FILE" ]] || die "缺少版本文件: $PACK_FILE"
  [[ -f "$INDEX_FILE" ]] || die "缺少索引文件: $INDEX_FILE"
  [[ -f "$WINDOW_TITLE_FILE" ]] || die "缺少窗口标题配置: $WINDOW_TITLE_FILE"
  [[ -f "$BUILD_SCRIPT" ]] || die "缺少构建脚本: $BUILD_SCRIPT"
}

is_release_file() {
  local candidate="$1"
  local release_file

  for release_file in "${RELEASE_FILES[@]}"; do
    [[ "$candidate" == "$release_file" ]] && return 0
  done
  return 1
}

check_changed_paths() {
  local path
  local -a changed_paths=()
  local -a staged_paths=()
  local -a untracked_paths=()

  mapfile -t changed_paths < <(git diff --name-only)
  mapfile -t staged_paths < <(git diff --cached --name-only)
  mapfile -t untracked_paths < <(git ls-files --others --exclude-standard)

  for path in "${changed_paths[@]}" "${staged_paths[@]}"; do
    [[ -z "$path" ]] && continue
    is_release_file "$path" || die "存在发布范围外的未提交改动: $path"
  done

  ((${#untracked_paths[@]} == 0)) ||
    die "存在未跟踪文件，请先处理: ${untracked_paths[0]}"
}

check_repository_state() {
  local repository_root
  local marker
  local marker_path

  repository_root="$(git rev-parse --show-toplevel 2>/dev/null)" ||
    die "当前目录不是 Git 仓库"
  [[ "$repository_root" == "$PROJECT_DIR" ]] ||
    die "脚本必须在仓库根目录运行"

  CURRENT_BRANCH="$(git symbolic-ref --quiet --short HEAD)" ||
    die "当前处于 detached HEAD 状态"

  for marker in MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD rebase-merge rebase-apply; do
    marker_path="$(git rev-parse --git-path "$marker")"
    [[ ! -e "$marker_path" ]] || die "Git 操作尚未完成: $marker"
  done

  check_changed_paths

  if [[ "$PUSH_RELEASE" == true ]]; then
    git remote get-url "$RELEASE_REMOTE" >/dev/null 2>&1 ||
      die "未配置远程仓库: $RELEASE_REMOTE"
  fi
}

read_pack_version() {
  local -a versions=()

  mapfile -t versions < <(
    sed -nE 's/^version[[:space:]]*=[[:space:]]*"([^"]+)"[[:space:]]*$/\1/p' "$PACK_FILE"
  )

  ((${#versions[@]} == 1)) ||
    die "$PACK_FILE 中必须恰好包含一个有效的 version 字段"
  PACK_VERSION="${versions[0]}"
}

validate_pack_version() {
  local release_core
  local prerelease
  local identifier
  local -a identifiers=()

  [[ "$PACK_VERSION" =~ $SEMVER_REGEX ]] ||
    die "版本号不符合语义化版本规范: $PACK_VERSION"

  release_core="${PACK_VERSION%%+*}"
  if [[ "$release_core" == *-* ]]; then
    prerelease="${release_core#*-}"
    IFS='.' read -r -a identifiers <<< "$prerelease"
    for identifier in "${identifiers[@]}"; do
      if [[ "$identifier" =~ ^[0-9]+$ && "$identifier" != "0" && "$identifier" == 0* ]]; then
        die "预发布数字标识不能包含前导零: $identifier"
      fi
    done
  fi

  EXPECTED_PACK_VERSION="$PACK_VERSION"
  TAG_NAME="v$PACK_VERSION"
  printf '发布版本: %s\n' "$PACK_VERSION"
}

check_release_conflicts() {
  local candidate_tag

  for candidate_tag in "$TAG_NAME" "$PACK_VERSION"; do
    if git show-ref --verify --quiet "refs/tags/$candidate_tag"; then
      if release_files_need_commit; then
        die "本地标签已存在，不能用于新的版本文件改动: $candidate_tag"
      fi

      RELEASE_COMMIT="$(git rev-parse HEAD)"
      [[ "$(git rev-list -n 1 "$candidate_tag")" == "$RELEASE_COMMIT" ]] ||
        die "本地标签已存在且未指向当前提交: $candidate_tag"
      [[ "$candidate_tag" == "$TAG_NAME" ]] ||
        die "发现不带 v 前缀的同版本标签: $candidate_tag"

      printf '本地标签已存在且指向当前提交，将安全重试后续步骤: %s\n' "$candidate_tag"
      return 0
    fi
  done
}

release_files_need_commit() {
  local release_file

  for release_file in "${RELEASE_FILES[@]}"; do
    if ! git diff --quiet HEAD -- "$release_file"; then
      return 0
    fi
  done
  return 1
}

read_window_title_version() {
  local source_file="$1"
  local -a versions=()

  mapfile -t versions < <(
    sed -nE "s/^title[[:space:]]*=[[:space:]]*'Cinderworks ([^']+) based on Minecraft [^']*'[[:space:]]*$/\\1/p" \
      "$source_file"
  )

  ((${#versions[@]} == 1)) ||
    die "$source_file 中必须恰好包含一个符合格式的 title 字段"
  WINDOW_TITLE_VERSION="${versions[0]}"
}

sync_window_title() {
  local previous_version

  read_window_title_version "$WINDOW_TITLE_FILE"
  previous_version="$WINDOW_TITLE_VERSION"

  if [[ "$previous_version" == "$PACK_VERSION" ]]; then
    printf '窗口标题版本已经是 %s，无需修改\n' "$PACK_VERSION"
    return 0
  fi

  SYNC_TEMP_FILE="$(mktemp "${WINDOW_TITLE_FILE}.tmp.XXXXXX")"
  sed -E \
    "s|^(title[[:space:]]*=[[:space:]]*'Cinderworks )[^']+( based on Minecraft [^']*'[[:space:]]*)$|\\1${PACK_VERSION}\\2|" \
    "$WINDOW_TITLE_FILE" > "$SYNC_TEMP_FILE"
  chmod --reference="$WINDOW_TITLE_FILE" "$SYNC_TEMP_FILE"

  read_window_title_version "$SYNC_TEMP_FILE"
  [[ "$WINDOW_TITLE_VERSION" == "$PACK_VERSION" ]] ||
    die "窗口标题版本更新失败，期望 $PACK_VERSION，实际 $WINDOW_TITLE_VERSION"

  mv -- "$SYNC_TEMP_FILE" "$WINDOW_TITLE_FILE"
  SYNC_TEMP_FILE=""
  printf '窗口标题版本: %s -> %s\n' "$previous_version" "$PACK_VERSION"
}

refresh_packwiz_index() {
  packwiz refresh
}

verify_release_changes() {
  check_changed_paths

  read_pack_version
  [[ "$PACK_VERSION" == "$EXPECTED_PACK_VERSION" ]] ||
    die "刷新索引后版本发生变化: $EXPECTED_PACK_VERSION -> $PACK_VERSION"

  read_window_title_version "$WINDOW_TITLE_FILE"
  [[ "$WINDOW_TITLE_VERSION" == "$PACK_VERSION" ]] ||
    die "窗口标题版本不一致: $WINDOW_TITLE_VERSION != $PACK_VERSION"

  printf '版本文件与 Packwiz 索引校验通过\n'
}

build_release_artifact() {
  local artifact_path="$TEMP_DIR/Cinderworks-${PACK_VERSION}.mrpack"

  bash "$BUILD_SCRIPT" "$artifact_path"
  [[ -s "$artifact_path" ]] || die "未生成有效的发布产物"
  printf '发布前构建验证通过\n'
}

create_release_commit() {
  git add -- "${RELEASE_FILES[@]}"

  if git diff --cached --quiet; then
    printf '版本文件没有变化，将在当前提交上创建标签\n'
  else
    git commit -m "chore: 更新版本至 $TAG_NAME"
  fi

  git diff --quiet || die "发布提交后仍存在未暂存改动"
  git diff --cached --quiet || die "发布提交后仍存在已暂存改动"
  RELEASE_COMMIT="$(git rev-parse HEAD)"
  printf '发布提交: %s\n' "${RELEASE_COMMIT:0:12}"
}

create_release_tag() {
  if git show-ref --verify --quiet "refs/tags/$TAG_NAME"; then
    [[ "$(git rev-list -n 1 "$TAG_NAME")" == "$RELEASE_COMMIT" ]] ||
      die "已有标签未指向本次发布提交: $TAG_NAME"
    printf '发布标签已存在，无需重复创建: %s\n' "$TAG_NAME"
    return 0
  fi

  git tag "$TAG_NAME" "$RELEASE_COMMIT"
  git show-ref --verify --quiet "refs/tags/$TAG_NAME" ||
    die "标签创建后无法验证: $TAG_NAME"
  printf '发布标签: %s\n' "$TAG_NAME"
}

push_release() {
  if [[ "$PUSH_RELEASE" != true ]]; then
    printf '未执行远程推送\n'
    return 0
  fi

  git push --atomic "$RELEASE_REMOTE" \
    "HEAD:refs/heads/$CURRENT_BRANCH" \
    "refs/tags/$TAG_NAME"
  printf '已原子推送分支 %s 和标签 %s\n' "$CURRENT_BRANCH" "$TAG_NAME"
}

print_release_summary() {
  printf '\n发布准备完成\n'
  printf '  版本: %s\n' "$PACK_VERSION"
  printf '  提交: %s\n' "$RELEASE_COMMIT"
  printf '  标签: %s\n' "$TAG_NAME"

  if [[ "$PUSH_RELEASE" == true ]]; then
    printf '  状态: 已推送，GitHub Actions 将创建 Release\n'
  else
    printf '  状态: 仅保存在本地\n'
    printf '  推送: git push --atomic %s HEAD:refs/heads/%s refs/tags/%s\n' \
      "$RELEASE_REMOTE" "$CURRENT_BRANCH" "$TAG_NAME"
  fi
}

main() {
  parse_arguments "$@"
  initialize

  start_step "检查依赖"
  check_requirements

  start_step "检查 Git 仓库状态"
  check_repository_state

  start_step "读取并校验版本"
  read_pack_version
  validate_pack_version

  start_step "检查发布冲突"
  check_release_conflicts

  start_step "同步窗口标题"
  sync_window_title

  start_step "刷新 Packwiz 索引"
  refresh_packwiz_index

  start_step "验证版本文件"
  verify_release_changes

  start_step "执行发布前构建"
  build_release_artifact

  start_step "创建发布提交与标签"
  create_release_commit
  create_release_tag

  start_step "推送发布"
  push_release

  CURRENT_STEP="完成"
  print_release_summary
}

main "$@"
