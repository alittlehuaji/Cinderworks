# Cinderworks | 余烬工坊

**WIP（开发中）** - 本整合包目前仍处于开发阶段，内容可能会随时更改，不建议用于正式游玩

火焰退去之后，余烬仍在暗处发红。这里没有等待被发现的繁荣：从第一根传动轴、第一台压块机开始，让齿轮、锅炉与铁路重新转动起来

**Cinderworks** 是一个以 [Create](https://modrinth.com/mod/create) 为核心，并结合 Applied Energistics 2 与 Mekanism 的 Minecraft 整合包。它围绕机械动力、工业生产、物流仓储与自动化展开，同时保留适合长期生存和多人协作的探索、建造与生活内容

## 基本信息

本项目基于 Minecraft 1.21.1与 NeoForge 21.1.238，使用 [Packwiz](https://packwiz.infra.link/) 作为管理工具

## 安装

### 使用 Modrinth 启动器

1. 下载本项目发布的 `.mrpack` 文件
2. 在 Modrinth App 中选择导入整合包，并选择该文件
3. 完成下载后启动实例

### 使用其他启动器

使用支持 Modrinth 整合包导入的启动器导入 `.mrpack`。请使用 Java 21，并保持 Minecraft 和 NeoForge 版本与上表一致

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

## 主要模组

> WIP - 本整合包仍在开发中，模组列表可能随时更改

### 核心工业

#### Create 机械动力

| 模组 | 类型 | 说明 | 链接 |
| :-- | :-- | :-- | :-- |
| Create | 核心 | 以旋转动力与运动机构为基础的工业核心模组 | [modrinth.com/mod/create](https://modrinth.com/mod/create) |
| Create Crafts & Additions | 附属 | 为 Create 添加电力转换，连接电气化系统 | [modrinth.com/mod/createaddition](https://modrinth.com/mod/createaddition) |
| Steam 'n' Rails | 附属 | 添加多种轨道、信号臂、列车员与连挂组件（1.21.1 非官方移植） | [modrinth.com/mod/create-steam-n-rails-1.21.1](https://modrinth.com/mod/create-steam-n-rails-1.21.1) |
| Create Railways Navigator | 附属 | 提供铁路网络导航与实时调度信息 | [modrinth.com/mod/create-railways-navigator](https://modrinth.com/mod/create-railways-navigator) |
| Create: New Age | 附属 | 基于 Create 动力的电气化扩展，添加发电与用电机器 | [modrinth.com/mod/create-new-age](https://modrinth.com/mod/create-new-age) |
| Create: The Factory Must Grow | 附属 | 工厂主题扩展，添加重工业机器与石油加工流程 | [modrinth.com/mod/create-tfmg](https://modrinth.com/mod/create-tfmg) |
| Create: Enchantment Industry | 附属 | 将附魔与 Create 流水线集成，实现自动化附魔生产 | [modrinth.com/mod/create-enchantment-industry](https://modrinth.com/mod/create-enchantment-industry) |
| Create: Central Kitchen | 附属 | 使用 Create 机械自动化 Farmer's Delight 等模组的食物加工 | [modrinth.com/mod/create-central-kitchen](https://modrinth.com/mod/create-central-kitchen) |
| Create Slice & Dice | 附属 | 扩展 Farmer's Delight 的 Create 自动化流程 | [modrinth.com/mod/slice-and-dice](https://modrinth.com/mod/slice-and-dice) |
| Create: Diesel Generators | 附属 | 添加柴油引擎、工业组件与原油精炼流程 | [modrinth.com/mod/create-diesel-generators](https://modrinth.com/mod/create-diesel-generators) |
| Create: Copper & Zinc | 附属 | 加工 Asurine 与 Veridium，提供可再生的铜与锌来源 | [modrinth.com/mod/create-copper-zinc](https://modrinth.com/mod/create-copper-zinc) |
| Create Ore Excavation | 附属 | 使用旋转动力驱动机器开采资源 | [modrinth.com/mod/create-ore-excavation](https://modrinth.com/mod/create-ore-excavation) |
| Create: Additional Logistics | 附属 | 扩展 Create 的物流组件并调整部分物流行为 | [modrinth.com/mod/create-additional-logistics](https://modrinth.com/mod/create-additional-logistics) |
| Create: FluidLogistic | 附属 | 将流体运输接入 Create 物流系统 | [modrinth.com/mod/createfluidlogistic](https://modrinth.com/mod/createfluidlogistic) |
| Create Contraption Terminals | 附属 | 让 Tom's Simple Storage 终端访问 Create 动态结构的库存 | [modrinth.com/mod/create-contraption-terminals](https://modrinth.com/mod/create-contraption-terminals) |
| Create: SchematicChecker | 服务端 | 扫描并拦截蓝图中的恶意 NBT，防止刷物品、卡服与崩服 | [modrinth.com/mod/createschematicchecker](https://modrinth.com/mod/createschematicchecker) |
| Create: FastSchematicCannon | 附属 | 提升蓝图炮的放置速度并修正服务端延迟 | [modrinth.com/mod/create-fast-schematic-cannon](https://modrinth.com/mod/create-fast-schematic-cannon) |
| Create: Dreams & Desires | 附属 | 添加 Create 风格的功能与装饰内容 | [modrinth.com/mod/create-dreams-and-desires](https://modrinth.com/mod/create-dreams-and-desires) |
| Create: Bells & Whistles | 附属 | 添加 Create 风格的装饰与细节方块 | [modrinth.com/mod/bellsandwhistles](https://modrinth.com/mod/bellsandwhistles) |
| Create: Blocks & Bogies | 附属 | 添加多种尺寸与结构的列车转向架及样式配置界面 | [modrinth.com/mod/blocks-bogies](https://modrinth.com/mod/blocks-bogies) |
| Create: Interiors | 附属 | 提供 Create 主题的家具与室内装饰 | [modrinth.com/mod/interiors](https://modrinth.com/mod/interiors) |
| Create: Design n' Decor | 附属 | 添加工业风格建筑装饰方块 | [modrinth.com/mod/create-design-n-decor](https://modrinth.com/mod/create-design-n-decor) |
| Create: Framed | 附属 | 添加彩色或着色的框架玻璃、平铺玻璃及门类变体 | [modrinth.com/mod/create-framed](https://modrinth.com/mod/create-framed) |
| Create: Prismatic Shine | 附属 | 添加玻璃机壳、玻璃脚手架与发光机壳 | [modrinth.com/mod/create-prismatic-shine](https://modrinth.com/mod/create-prismatic-shine) |
| Create: Dragons Plus | 附属 | 添加批量染色、冻结、末地灌注、打磨与流体舱等功能 | [modrinth.com/mod/create-dragons-plus](https://modrinth.com/mod/create-dragons-plus) |
| CreateBetterFps | 优化 | 开启光影时优化 Create 的客户端渲染性能 | [modrinth.com/mod/createbetterfps](https://modrinth.com/mod/createbetterfps) |

#### Applied Energistics 2 应用能源

| 模组 | 类型 | 说明 | 链接 |
| :-- | :-- | :-- | :-- |
| Applied Energistics 2 | 核心 | ME 网络存储与自动化核心模组 | [modrinth.com/mod/ae2](https://modrinth.com/mod/ae2) |
| Applied Energistics 2 Wireless Terminals | 附属 | 为 AE2 添加多种无线终端，远程访问 ME 网络 | [modrinth.com/mod/applied-energistics-2-wireless-terminals](https://modrinth.com/mod/applied-energistics-2-wireless-terminals) |
| AdvancedAE | 附属 | 添加高级样板、量子合成与计算设备，以及多种便利功能 | [modrinth.com/mod/advancedae](https://modrinth.com/mod/advancedae) |
| GuideME | 依赖 | 通用指南书工具库，支持 Markdown 与实时 3D 场景 | [modrinth.com/mod/guideme](https://modrinth.com/mod/guideme) |

#### Mekanism 通用机械

| 模组 | 类型 | 说明 | 链接 |
| :-- | :-- | :-- | :-- |
| Mekanism | 核心 | 多阶段矿石处理、化工与能源的工业模组 | [modrinth.com/mod/mekanism](https://modrinth.com/mod/mekanism) |
| Mekanism Generators | 附属 | 添加多种发电机、裂变与聚变反应堆及涡轮 | [modrinth.com/mod/mekanism-generators](https://modrinth.com/mod/mekanism-generators) |
| Mekanism Additions | 附属 | 添加 Mekanism 额外方块与实体内容 | [modrinth.com/mod/mekanism-additions](https://modrinth.com/mod/mekanism-additions) |
| Mekanism Tools | 附属 | 添加 Mekanism 材料的工具与装备 | [modrinth.com/mod/mekanism-tools](https://modrinth.com/mod/mekanism-tools) |

---

### 存储与背包

| 模组 | 类型 | 说明 | 链接 |
| :-- | :-- | :-- | :-- |
| Storage Drawers | 内容 | 可交互的大容量抽屉式物品存储系统 | [modrinth.com/mod/storagedrawers](https://modrinth.com/mod/storagedrawers) |
| Tom's Simple Storage Mod | 内容 | 原版风格的简易存储网络，提供连接器及有线、无线终端 | [modrinth.com/mod/toms-storage](https://modrinth.com/mod/toms-storage) |
| Sophisticated Backpacks | 内容 | 可放置、染色与升级的多功能背包，支持过滤、拾取与补给等升级 | [modrinth.com/mod/sophisticated-backpacks](https://modrinth.com/mod/sophisticated-backpacks) |

---

### 生活与内容

| 模组 | 类型 | 说明 | 链接 |
| :-- | :-- | :-- | :-- |
| Farmer's Delight | 内容 | 扩展农业与烹饪系统，添加大量食材与食谱 | [modrinth.com/mod/farmers-delight](https://modrinth.com/mod/farmers-delight) |
| [Let's Do] Farm & Charm | 内容 | 添加进阶农业、谷物与水果，以及农家菜加工设备 | [modrinth.com/mod/lets-do-farm-charm](https://modrinth.com/mod/lets-do-farm-charm) |
| [Let's Do] Meadow | 内容 | 扩展草甸生物群系，添加两个子群系与奶酪制作流程 | [modrinth.com/mod/lets-do-meadow](https://modrinth.com/mod/lets-do-meadow) |
| [Let's Do] Vinery | 内容 | 添加葡萄酒酿造与葡萄园相关内容 | [modrinth.com/mod/lets-do-vinery](https://modrinth.com/mod/lets-do-vinery) |
| [Let's Do] Beachparty | 内容 | 添加沙滩家具、鸡尾酒、收音机、棕榈树与热带装饰 | [modrinth.com/mod/lets-do-beachparty](https://modrinth.com/mod/lets-do-beachparty) |
| Another Furniture | 内容 | 添加大量实用家具方块，适合室内建造 | [modrinth.com/mod/another-furniture](https://modrinth.com/mod/another-furniture) |
| Supplementaries | 内容 | 添加多种装饰性与功能性小物件 | [modrinth.com/mod/supplementaries](https://modrinth.com/mod/supplementaries) |
| FramedBlocks | 内容 | 可伪装外观的框架方块，适合建筑 | [modrinth.com/mod/framedblocks](https://modrinth.com/mod/framedblocks) |
| Naturalist | 内容 | 添加多种原版风格的野生动物 | [modrinth.com/mod/naturalist](https://modrinth.com/mod/naturalist) |
| Touhou Little Maid | 内容 | 添加可交互的东方风格女仆 NPC | [modrinth.com/mod/touhou-little-maid](https://modrinth.com/mod/touhou-little-maid) |
| MaidUseHandCrank | 附属 | 允许女仆 NPC 操作 Create 手摇曲柄 | [modrinth.com/mod/maidusehandcrank](https://modrinth.com/mod/maidusehandcrank) |
| Easy Villagers | 内容 | 允许拾取村民，并提供交易、繁殖、铁农场等单方块设施 | [modrinth.com/mod/easy-villagers](https://modrinth.com/mod/easy-villagers) |
| FallingTree | 辅助 | 支持整棵树一次性伐倒 | [modrinth.com/mod/fallingtree](https://modrinth.com/mod/fallingtree) |
| RightClickHarvest | 辅助 | 右键收割成熟作物并自动重新种植 | [modrinth.com/mod/rightclickharvest](https://modrinth.com/mod/rightclickharvest) |

---

### 世界生成

| 模组 | 类型 | 说明 | 链接 |
| :-- | :-- | :-- | :-- |
| Terralith | 内容 | 大幅重塑主世界地形与生物群系 | [modrinth.com/mod/terralith](https://modrinth.com/mod/terralith) |
| Tectonic | 内容 | 增强地形起伏，生成更宏伟的山脉与地貌 | [modrinth.com/mod/tectonic](https://modrinth.com/mod/tectonic) |
| Lithostitched | 依赖 | 世界生成模组的通用 API，供 Terralith 等使用 | [modrinth.com/mod/lithostitched](https://modrinth.com/mod/lithostitched) |

---

### 实用工具

| 模组 | 类型 | 说明 | 链接 |
| :-- | :-- | :-- | :-- |
| Just Enough Items (JEI) | 辅助 | 游戏内物品与合成配方查询 | [modrinth.com/mod/jei](https://modrinth.com/mod/jei) |
| Jade 🔍 | 辅助 | 准星悬停显示方块与实体信息 | [modrinth.com/mod/jade](https://modrinth.com/mod/jade) |
| Xaero's Minimap | 辅助 | 小地图，显示地形、实体与航点 | [modrinth.com/mod/xaeros-minimap](https://modrinth.com/mod/xaeros-minimap) |
| Xaero's World Map | 辅助 | 全地图，可查看已探索区域 | [modrinth.com/mod/xaeros-world-map](https://modrinth.com/mod/xaeros-world-map) |
| XaeroPlus | 附属 | Xaero 地图扩展，添加额外叠加层与功能 | [modrinth.com/mod/xaeroplus](https://modrinth.com/mod/xaeroplus) |
| WorldEdit | 辅助 | 强力的游戏内地图编辑工具 | [modrinth.com/mod/worldedit](https://modrinth.com/mod/worldedit) |
| Forgematica | 辅助 | 原版风格蓝图工具，支持结构预览与放置 | [modrinth.com/mod/forgematica](https://modrinth.com/mod/forgematica) |
| Inventory Profiles Next | 辅助 | 背包自动整理、物品锁定与快速补货 | [modrinth.com/mod/inventory-profiles-next](https://modrinth.com/mod/inventory-profiles-next) |
| AppleSkin | 辅助 | 显示饱食度与饥饿值的详细信息 | [modrinth.com/mod/appleskin](https://modrinth.com/mod/appleskin) |
| Shulker Box Tooltip | 辅助 | 悬停预览潜影盒内容 | [modrinth.com/mod/shulkerboxtooltip](https://modrinth.com/mod/shulkerboxtooltip) |
| Open Parties and Claims | 辅助 | 领地圈地与队伍管理系统 | [modrinth.com/mod/open-parties-and-claims](https://modrinth.com/mod/open-parties-and-claims) |
| Simple Voice Chat | 辅助 | 游戏内近距离语音通话 | [modrinth.com/mod/simple-voice-chat](https://modrinth.com/mod/simple-voice-chat) |
| Chunky | 辅助 | 预生成区块，减少探索时的卡顿 | [modrinth.com/mod/chunky](https://modrinth.com/mod/chunky) |
| NBT Autocomplete | 辅助 | 命令行 NBT 标签自动补全 | [modrinth.com/mod/nbt-autocomplete](https://modrinth.com/mod/nbt-autocomplete) |

---

### 客户端体验与性能优化

| 模组 | 类型 | 说明 | 链接 |
| :-- | :-- | :-- | :-- |
| Iris Shaders | 客户端 | 加载兼容 OptiFine 格式的光影包 | [modrinth.com/mod/iris](https://modrinth.com/mod/iris) |
| Sodium | 优化 | 替换原版渲染引擎，提升帧率并减少微卡顿 | [modrinth.com/mod/sodium](https://modrinth.com/mod/sodium) |
| RyoamicLights | 客户端 | 添加动态光源，使手持与掉落的发光物品照亮环境 | [modrinth.com/mod/ryoamiclights](https://modrinth.com/mod/ryoamiclights) |
| Yes Steve Model | 内容 | 替换原版玩家模型，提供自定义模型与动画支持 | [modrinth.com/mod/yes-steve-model](https://modrinth.com/mod/yes-steve-model) |
| Not Enough Animations | 客户端 | 将第一人称已有但第三人称缺失的动作补充到玩家模型 | [modrinth.com/mod/not-enough-animations](https://modrinth.com/mod/not-enough-animations) |
| [EMF] Entity Model Features | 客户端 | 支持资源包使用 OptiFine 格式的自定义实体模型 | [modrinth.com/mod/entity-model-features](https://modrinth.com/mod/entity-model-features) |
| [ETF] Entity Texture Features | 客户端 | 支持资源包使用发光、随机与自定义实体贴图 | [modrinth.com/mod/entitytexturefeatures](https://modrinth.com/mod/entitytexturefeatures) |
| Rock'n Roller | 客户端 | Item Scroller 的非官方 Forge 移植，提供物品栏滚轮搬运等操作 | [modrinth.com/mod/rocknroller](https://modrinth.com/mod/rocknroller) |
| ImmediatelyFast | 优化 | 优化即时模式、界面与实体渲染 | [modrinth.com/mod/immediatelyfast](https://modrinth.com/mod/immediatelyfast) |
| Entity Culling | 优化 | 跳过不可见方块实体与实体的渲染 | [modrinth.com/mod/entityculling](https://modrinth.com/mod/entityculling) |
| Cull Leaves | 优化 | 剔除树叶内部不可见面，降低渲染开销 | [modrinth.com/mod/cull-leaves](https://modrinth.com/mod/cull-leaves) |
| ModernFix | 优化 | 同时优化客户端与服务端的性能、内存占用并修复问题 | [modrinth.com/mod/modernfix](https://modrinth.com/mod/modernfix) |
| FerriteCore | 优化 | 同时降低客户端与服务端的内存占用 | [modrinth.com/mod/ferrite-core](https://modrinth.com/mod/ferrite-core) |

---

### 服务端管理

| 模组 | 类型 | 说明 | 链接 |
| :-- | :-- | :-- | :-- |
| LuckPerms | 服务端 | 权限管理系统，支持精细化玩家权限配置 | [modrinth.com/mod/luckperms](https://modrinth.com/mod/luckperms) |
| CoreProtectNeo | 服务端 | 方块操作日志与回滚，防止破坏 | [modrinth.com/mod/coreprotectneo](https://modrinth.com/mod/coreprotectneo) |
| Curtain | 服务端 | 类似 Fabric Carpet 的技术工具，提供规则、假人与性能监控功能 | [modrinth.com/mod/curtain](https://modrinth.com/mod/curtain) |
| FTB Essentials | 服务端 | 提供传送、Home、Warp 等常用服务端指令 | [curseforge.com/minecraft/mc-mods/ftb-essentials-forge](https://www.curseforge.com/minecraft/mc-mods/ftb-essentials-forge) |
| TabTPS | 服务端 | 在 Tab 列表中显示服务器 TPS 与 MSPT | [modrinth.com/mod/tabtps](https://modrinth.com/mod/tabtps) |
| spark | 服务端 | 性能分析器，用于诊断服务端卡顿 | [modrinth.com/mod/spark](https://modrinth.com/mod/spark) |
| NetherPortalFix | 服务端 | 修复多人游戏中下界传送门目标错乱问题 | [modrinth.com/mod/netherportalfix](https://modrinth.com/mod/netherportalfix) |

---

### 依赖库

| 模组 | 类型 | 说明 | 链接 |
| :-- | :-- | :-- | :-- |
| Geckolib | 依赖 | 3D 动画库，供多个内容模组使用 | [modrinth.com/mod/geckolib](https://modrinth.com/mod/geckolib) |
| Architectury API | 依赖 | 跨平台模组开发 API | [modrinth.com/mod/architectury-api](https://modrinth.com/mod/architectury-api) |
| KubeJS | 依赖 | 脚本化模组配置与合成修改框架 | [modrinth.com/mod/kubejs](https://modrinth.com/mod/kubejs) |
| Rhino | 依赖 | KubeJS 的 JavaScript 运行时 | [modrinth.com/mod/rhino](https://modrinth.com/mod/rhino) |
| Kotlin for Forge | 依赖 | Kotlin 语言运行时，供使用 Kotlin 的模组使用 | [modrinth.com/mod/kotlin-for-forge](https://modrinth.com/mod/kotlin-for-forge) |
| CreativeCore | 依赖 | 通用工具库，供多个模组使用 | [modrinth.com/mod/creativecore](https://modrinth.com/mod/creativecore) |
| Moonlight Lib | 依赖 | 通用工具库，供 Supplementaries 等模组使用 | [modrinth.com/mod/moonlight](https://modrinth.com/mod/moonlight) |
| Puzzles Lib | 依赖 | 通用工具库，供多个模组使用 | [modrinth.com/mod/puzzles-lib](https://modrinth.com/mod/puzzles-lib) |
| Patchouli | 依赖 | 游戏内指南书框架 | [modrinth.com/mod/patchouli](https://modrinth.com/mod/patchouli) |
| Curios API | 依赖 | 扩展装备槽位 API | [modrinth.com/mod/curios](https://modrinth.com/mod/curios) |
| Cloth Config API | 依赖 | 模组配置界面 API | [modrinth.com/mod/cloth-config](https://modrinth.com/mod/cloth-config) |
| Balm | 依赖 | 跨平台模组工具库，供 NetherPortalFix 等使用 | [modrinth.com/mod/balm](https://modrinth.com/mod/balm) |
| Sophisticated Core | 依赖 | Sophisticated Backpacks 的核心库 | [modrinth.com/mod/sophisticated-core](https://modrinth.com/mod/sophisticated-core) |
| Melody | 依赖 | 基于 OpenAL 的背景音乐播放库 | [modrinth.com/mod/melody](https://modrinth.com/mod/melody) |
| DragonLib | 依赖 | 基于 Architectury API 的跨加载器模组库与开发框架 | [modrinth.com/mod/dragonlib](https://modrinth.com/mod/dragonlib) |

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

```bash
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
