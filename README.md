# HappyMC Ember: Cinderworks

> **余烬工坊**

**WIP（开发中）** - 本整合包目前仍处于开发阶段，内容可能会随时更改，不建议用于正式游玩

火焰退去之后，余烬仍在暗处发红。这里没有等待被发现的繁荣：从第一根传动轴、第一台压块机开始，让齿轮、锅炉与铁路重新转动起来

**HappyMC Ember: Cinderworks** 是一个以 [Create](https://modrinth.com/mod/create) 为核心的 Minecraft 整合包。它围绕机械动力、工业生产与自动化展开，并保留适合长期生存和多人协作的探索、建造与生活内容

`HappyMC Ember` 是该项目的系列名称，本义是“余烬、余火、火星”——火焰将熄未熄之后，仍在暗处微红、微热的炭火

`Cinderworks` 由 *cinder*（余烬、炭屑）与 *works*（工坊、工业设施）组成：在余火未尽的世界里建起一座会呼吸的机械工坊

## 基本信息

| 项目 | 内容 |
| --- | --- |
| Minecraft | `1.21.1` |
| 模组加载器 | NeoForge `21.1.235` |
| 管理工具 | [Packwiz](https://packwiz.infra.link/) |

## 内容方向

- **机械生产**：用 Create 的动能网络、物流、加工链与装置搭建属于自己的生产体系
- **工业扩展**：补充能源、采掘、铁路、飞行和更多 Create 机械玩法
- **仓储与自动化**：通过 Applied Energistics 2 及其扩展整理物资，让产线持续运作
- **建造与生活**：Farmer's Delight、Create Central Kitchen、装饰与室内模组让基地更有生活感
- **探索与世界生成**：Terralith、Tectonic 等内容让远行、选址与建设更值得投入

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
packwiz modrinth export -o "HappyMC-Ember-Cinderworks.mrpack"
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
