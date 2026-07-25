# Cinderworks | 余烬工坊

**WIP（开发中）** - 本整合包目前仍处于开发阶段，内容可能会随时更改，不建议用于正式游玩

火焰退去之后，余烬仍在暗处发红。这里没有等待被发现的繁荣：从第一根传动轴、第一台压块机开始，让齿轮、锅炉与铁路重新转动起来

**Cinderworks** 是一个以 [Create](https://modrinth.com/mod/create) 为核心，并结合 Applied Energistics 2 与 Mekanism 的 Minecraft 整合包。它围绕机械动力、工业生产、物流仓储与自动化展开，同时保留适合长期生存和多人协作的探索、建造与生活内容

## 基本信息

本项目基于 Minecraft 1.21.1与 NeoForge 21.1.235，使用 [Packwiz](https://packwiz.infra.link/) 作为管理工具

## 主要模组

| 分类 | 主要模组 | 内容 |
| --- | --- | --- |
| 核心机械 | Create | 动能机械、加工、物流、装配与自动化基础 |
| Create 扩展 | Bells & Whistles、Copper & Zinc、Crafts & Additions、Diesel Generators、Dreams & Desires、Enchantment Industry、FastSchematicCannon、New Age | 扩展装饰、材料、电力、柴油、附魔、蓝图与机械玩法 |
| 交通与采掘 | Steam 'n' Rails、Create Railways Navigator、Create Ore Excavation | 铁路建设、线路导航与机械采矿 |
| 仓储物流 | Applied Energistics 2、AE2 Wireless Terminals、ME Requester、Storage Drawers | ME 网络、无线访问、自动请求与抽屉存储 |
| 工业科技 | Mekanism | 多级矿物处理、机器与能源体系 |
| 农业烹饪 | Farmer's Delight、Create Central Kitchen、Create Slice & Dice | 农作物加工、厨房自动化与食物制作 |
| 生活与装饰 | Another Furniture、Create: Interiors、Farm & Charm、Meadow、Vinery、Beachparty、Supplementaries | 家具、室内布置、农耕、酿造与休闲装饰 |
| 世界探索 | Terralith、Tectonic、Naturalist、Create: Dragons Plus | 地形重塑、生物群系、动物与探索内容 |
| 实用工具 | REI、Jade、AppleSkin、Inventory Profiles Next、Forgematica、WorldEdit | 配方查询、信息提示、物品栏管理、投影建造与编辑 |
| 地图与协作 | Xaero's Minimap、Xaero's World Map、XaeroPlus、FTB Teams、FTB Chunks、FTB Essentials、e4mc | 导航、领地、队伍、基础指令与便捷联机 |
| 画面与性能 | Sodium、Iris Shaders、ImmediatelyFast、ModernFix、FerriteCore、Entity Culling、Cull Leaves | 渲染、光影支持、内存与性能优化 |

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

## 致谢

感谢 Create、各个附属模组及本整合包所使用的全部开源项目作者

## 许可证

本整合包采用 [MIT 许可证](LICENSE) 授权。

**重要说明：**
- 本许可证仅适用于整合包的配置文件、脚本和自定义内容
- 整合包中的各个模组 **各自拥有独立的许可证**
- 使用或分发本整合包时，请确保遵守各模组的许可证要求
- 部分模组可能禁止商业使用或有其他使用限制
