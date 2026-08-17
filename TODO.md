# Todo list

- [ ] 完善 Readme 模组列表
- [ ] 完善服务端安装说明(Docs)
- [x] 添加自动发布脚本（自动从 pack.toml 读取版本号并更新 customwindowtitle-client.toml，减少手动同步负担）
- [x] 重构 build.sh 版本检查机制（精确比较 pack.toml 与 customwindowtitle-client.toml 中的版本）
- [x] 完善 README（说明手动触发 workflow 不创建 release）
- [ ] 重构构建脚本(资源包下载过于依赖外部 Github API)
- [ ] 创建 `server-overrides/` 时加入 `config/supplementaries-common.toml`，并设置 `tweaks.ai_tweaks.raiders_dismount_boats = false`

## Next version plan
- [ ] 添加 Create: Connected （等待解决此 issue <https://github.com/hlysine/create_connected/issues/300>）

## Q&A

### 掠夺者为什么会从刷铁机的矿车中自行离开

Supplementaries 默认启用 `tweaks.ai_tweaks.raiders_dismount_boats`。尽管配置名称提及船只，该功能实际会为袭击者（包括掠夺者）追加离开载具的 AI，而其默认载具标签包含矿车，因此会导致依赖掠夺者矿车的刷铁机失效

在服务端的 `config/supplementaries-common.toml` 中作如下设置，并重启服务端：

```toml
[tweaks.ai_tweaks]
raiders_dismount_boats = false
```

此设置仅关闭袭击者主动离开载具的行为，`pillagers_use_cannon_boats` 与该问题无关，无需修改
