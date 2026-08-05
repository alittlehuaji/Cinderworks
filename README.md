# Cinderworks | 余烬工坊

**WIP（开发中）** - 本整合包目前仍处于开发阶段，内容可能会随时更改，不建议用于正式游玩

火焰退去之后，余烬仍在暗处发红。这里没有等待被发现的繁荣：从第一根传动轴、第一台压块机开始，让齿轮、锅炉与铁路重新转动起来

**Cinderworks** 是一个以 [Create](https://modrinth.com/mod/create) 为核心，并结合 Applied Energistics 2 与 Mekanism 的 Minecraft 整合包。它围绕机械动力、工业生产、物流仓储与自动化展开，同时保留适合长期生存和多人协作的探索、建造与生活内容

## Todo list
- [ ] 完善 Readme 模组列表
- [ ] 完善服务端安装说明(Docs)
- [ ] 添一个自动发布脚本(自动从 pack.toml 读取版本号并更新 customwindowtitle-client.toml 减少手动同步负担)
- [ ] 重构 build.sh 版本检查机制 (build.sh 版本标签检查过于宽松, 假设 customwindowtitle-client.toml 里有 v0.1.0-beta.33 但 pack.toml 是 v0.1.0-beta.3, build.sh 仍然会通过)
- [ ] 完善 README (在 README 说明手动触发 workflow 不创建 release)
- [ ] 重构构建脚本(资源包下载过于依赖外部 Github API)
- [ ] 创建 `server-overrides/` 时加入 `config/supplementaries-common.toml`，并设置 `tweaks.ai_tweaks.raiders_dismount_boats = false`

## Next version plan
- [ ] 添加 Create: Connected （等待解决此 issue <https://github.com/hlysine/create_connected/issues/300>）
- [ ] 添加 Create: Contraption Terminals （等待解决此 issue <https://github.com/tom5454/Create-Contraption-Terminals/issues/10>）

## 基本信息

本项目基于 Minecraft 1.21.1与 NeoForge 21.1.235，使用 [Packwiz](https://packwiz.infra.link/) 作为管理工具

## 主要模组

> WIP - 本整合包仍在开发中，模组列表可能随时更改

## 安装

### 使用 Modrinth 启动器

1. 下载本项目发布的 `.mrpack` 文件
2. 在 Modrinth App 中选择导入整合包，并选择该文件
3. 完成下载后启动实例

### 使用其他启动器

使用支持 Modrinth 整合包导入的启动器导入 `.mrpack`。请使用 Java 21，并保持 Minecraft 和 NeoForge 版本与上表一致

## Q&A

### 掠夺者为什么会从刷铁机的矿车中自行离开

Supplementaries 默认启用 `tweaks.ai_tweaks.raiders_dismount_boats`。尽管配置名称提及船只，该功能实际会为袭击者（包括掠夺者）追加离开载具的 AI，而其默认载具标签包含矿车，因此会导致依赖掠夺者矿车的刷铁机失效

在服务端的 `config/supplementaries-common.toml` 中作如下设置，并重启服务端：

```toml
[tweaks.ai_tweaks]
raiders_dismount_boats = false
```

此设置仅关闭袭击者主动离开载具的行为，`pillagers_use_cannon_boats` 与该问题无关，无需修改

## 本地维护与导出

本仓库由 Packwiz 管理。安装 Packwiz 后，在仓库根目录执行：

```sh
# 将元数据变更写入索引
packwiz refresh

# 导出供启动器导入的 Modrinth 整合包
packwiz modrinth export
```

模组的元数据保存在 `mods/*.pw.toml`，而 `pack.toml` 和 `index.toml` 是整合包的版本与索引来源。请通过 Packwiz 添加、更新或移除模组，避免直接手改索引

详细信息请见 [Packwiz 文档](https://packwiz.infra.link)

## 自动化构建脚本 `build.sh`

`build.sh` 用于一键导出 Modrinth 整合包（`.mrpack`），并自动完成两类额外工作：从 GitHub Releases 拉取、校验并嵌入外部资源包（如汉化资源包）；将仓库的 `client-overrides/` 等覆盖目录以正确的顶层路径注入整合包。相比手动执行 `packwiz modrinth export`，脚本额外完成版本标签一致性校验、索引一致性校验、资源包下载与 SHA-256 校验、ZIP 完整性校验，以及 overrides 目录的手动注入

### 依赖

脚本依赖以下命令，缺失会直接报错退出：

| 命令 | 用途 |
| --- | --- |
| `packwiz` | 刷新索引、导出整合包 |
| `curl` | 下载 GitHub Release 资源 |
| `jq` | 解析 GitHub API 响应 |
| `unzip` | 校验资源包 ZIP 完整性 |
| `zip` | 将资源包写入整合包 |
| `sha256sum` | 校验资源包摘要 |
| `cmp` | 比对刷新前后索引是否变更 |

此外要求仓库根目录存在 `pack.toml` 与 `index.toml`

### 用法

```sh
./build.sh <输出文件.mrpack>
```

输出路径支持相对路径与绝对路径，扩展名必须为 `.mrpack`，否则报错退出。若文件已存在会被覆盖

示例：

```sh
# 输出到当前目录
./build.sh Cinderworks.mrpack

# 输出到绝对路径
./build.sh /tmp/build/Cinderworks-1.0.0.mrpack
```

### 构建流程

脚本固定执行 5 个阶段，每阶段失败即中止：

| 步骤 | 阶段 | 说明 |
| --- | --- | --- |
| `[1/5]` | 校验版本标签 | 从 `pack.toml` 读取 `version`，加上 `v` 前缀后检查所有声明文件是否包含该标签。文件缺失、版本字段无法读取或标签不一致都会中止构建 |
| `[2/5]` | 检查 Packwiz 索引 | 执行 `packwiz refresh` 并比对 `pack.toml`、`index.toml` 是否发生变化。若索引已过期（即 refresh 产生了未提交的变更），报错提示先提交变更再重试，避免导出与仓库状态不一致的产物 |
| `[3/5]` | 导出 Modrinth 整合包 | 调用 `packwiz modrinth export` 生成基础 `.mrpack` |
| `[4/5]` | 下载并校验资源包 | 逐个从配置的 GitHub Releases 下载资源包，校验 SHA-256 摘要与 ZIP 完整性后放入临时嵌入目录 |
| `[5/5]` | 注入 overrides 与资源包 | 将仓库的 `client-overrides/`、`server-overrides/`（若存在）以顶层路径 `zip` 注入 `.mrpack`，随后注入已下载的资源包至 `client-overrides/resourcepacks/` |

构建结束后会打印实际嵌入的资源包文件名与最终产物路径

### 版本标签校验

`pack.toml` 的 `version` 是整合包版本的唯一来源。构建开始时，脚本为该版本添加 `v` 前缀，并校验指定文件中是否直接包含完整标签。例如 `version = "0.1.0-beta.3"` 时，待匹配标签为 `v0.1.0-beta.3`

需校验的文件在脚本顶部的 `VERSION_TAG_FILES` 数组中集中维护：

```bash
readonly VERSION_TAG_PREFIX="v"
declare -ra VERSION_TAG_FILES=(
  "client-overrides/config/customwindowtitle-client.toml"
)
```

如有其它配置、文本或脚本也需要同步版本，只需将相对路径追加到数组。文件不存在或未包含完整版本标签时，构建会在导出前终止并指出对应文件

### overrides 目录处理

packwiz 导出时会将仓库根目录的所有文件塞进 `.mrpack` 的 `overrides/` 路径下。但 Modrinth 整合包格式中，"仅客户端"的覆盖文件应位于顶层的 `client-overrides/`，"仅服务端"的应位于 `server-overrides/`。若交由 packwiz 处理，这些目录会被错误嵌套成 `overrides/client-overrides/...`，启动器导入后无法被识别为客户端覆盖

为避免此问题，脚本采用 **packwiz 只管模组、overrides 由脚本手动注入** 的分工：

1. `.packwizignore` 中排除 `client-overrides/` 与 `server-overrides/`，使 packwiz 完全不索引这两个目录
2. packwiz 导出基础 `.mrpack` 后，脚本在仓库根目录用 `zip -r` 将这两个目录以顶层路径直接写入整合包

涉及的 overrides 目录在脚本顶部的 `OVERRIDE_DIRS` 数组中声明：

```bash
declare -ra OVERRIDE_DIRS=(
  "client-overrides"
  "server-overrides"
)
```

每个目录的处理规则：

| 目录 | 行为 |
| --- | --- |
| `client-overrides` | 存在则打包，内容覆盖客户端实例（如游戏设置、客户端模组配置） |
| `server-overrides` | 预留位，存在则打包，不存在自动跳过 |

脚本下载的资源包会被放入 `client-overrides/resourcepacks/`，与仓库内已有的 `client-overrides/` 内容合并后一同注入，路径互不冲突

> 注意：`client-overrides/mods/` 下的客户端专属模组由 packwiz 根据 `.pw.toml` 中的 `side = "client"` 标记自动归置，不属脚本管辖范围。脚本只接管 `config/`、`resourcepacks/` 等非模组覆盖文件

### 配置资源包

资源包列表在脚本顶部的 `RESOURCE_PACKS` 数组中声明，采用声明式配置。每条记录格式为：

```
名称|GitHub Releases API 地址|资源包文件名正则
```

三段以 `|` 分隔，均不可为空：

| 字段 | 含义 |
| --- | --- |
| 名称 | 仅用于日志与错误信息展示，便于多包时定位问题 |
| GitHub Releases API 地址 | 形如 `https://api.github.com/repos/<owner>/<repo>/releases/latest`，指向最新正式 Release |
| 资源包文件名正则 | 用于从 Release 的 assets 中匹配目标资源包文件，取第一个匹配项 |

默认配置：

```bash
declare -ra RESOURCE_PACKS=(
  "汉化资源包|https://api.github.com/repos/alittlehuaji/Cinderworks-TranslatePack/releases/latest|^Cinderworks_TranslatePack\.zip$"
)
```

新增资源包只需追加一行，无需改动其它逻辑：

```bash
declare -ra RESOURCE_PACKS=(
  "汉化资源包|https://api.github.com/repos/alittlehuaji/Cinderworks-TranslatePack/releases/latest|^Cinderworks_TranslatePack\.zip$"
  "音乐包|https://api.github.com/repos/xxx/MusicPack/releases/latest|^MusicPack-.*\.zip$"
)
```

### 资源包校验机制

每个资源包下载后须依次通过以下校验，任一失败即中止构建：

1. **Asset 匹配** — Release 中存在与正则匹配的 asset
2. **摘要存在** — GitHub 返回的 `digest` 字段必须为 `sha256:` 前缀格式
3. **SHA-256 校验** — 下载内容与 GitHub 公布的摘要一致
4. **ZIP 完整性** — `unzip -t` 通过，确保文件未损坏

校验失败时错误信息以 `[资源包名称]` 为前缀，多包场景下可快速定位是哪个包失败

### 限制

- 仅支持从 **GitHub Releases** 拉取资源包，暂不支持直链或其它平台
- 仅匹配最新正式 Release（`/releases/latest`），不含预发布
- 资源包固定嵌入至 `client-overrides/resourcepacks/`。如需首次启动时启用某个资源包，还必须在 `client-overrides/options.txt` 的 `resourcePacks` 中加入对应的 `file/<资源包文件或目录名>` 标识
- 要求 GitHub Release 的 asset 提供 `sha256` 摘要字段，否则报错
- overrides 目录仅支持仓库内的 `client-overrides/` 与 `server-overrides/`，其它覆盖路径需扩展 `OVERRIDE_DIRS`
- `.packwizignore` 必须同步排除 `OVERRIDE_DIRS` 中声明的目录，否则 packwiz 会重复索引导致路径冲突

## 致谢

感谢 Create、各个附属模组及本整合包所使用的全部开源项目作者

## 许可证

本整合包采用 [MIT 许可证](LICENSE) 授权。

**重要说明：**
- 本许可证仅适用于整合包的配置文件、脚本和自定义内容
- 整合包中的各个模组 **各自拥有独立的许可证**
- 使用或分发本整合包时，请确保遵守各模组的许可证要求
- 部分模组可能禁止商业使用或有其他使用限制
