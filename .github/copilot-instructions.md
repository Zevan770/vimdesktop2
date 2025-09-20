# Copilot Instructions for vimd (AutoHotkey v2)

## 项目架构与核心组件
- 主要逻辑基于 AutoHotkey v2 脚本实现，核心入口为 `vimd.ahk`。
- 主要类与文件：
  - `VimD`（vimd.ahk）：全局状态、窗口、模式与错误处理的管理中心。
  - `VimDMode`（VimDMode.ahk）：管理单个模式的状态与按键处理。
  - `VimDKeySequence`（VimDKeySequence.ahk）：按键序列的解析与转换。
  - `VimDAction`（VimDAction.ahk）：按键序列映射的动作对象。
  - `VimDActionManager`（VimDActionManager.ahk）：动作查找与前缀匹配。
  - `VimDWindow`（VimDWindow.ahk）：每个窗口的模式与状态。
- 结构设计参考 Vim 的模式与 map 命令参数（如 `<buffer>`, `<nowait>`, `<silent>` 等）。

## 关键开发工作流
- 直接编辑 `.ahk` 文件，无标准构建、测试或 lint 流程。
- 运行脚本：
  - 主入口：`vimd.ahk`
  - 推荐命令：`AutoHotkey.exe vimd.ahk | Write-Host`（必须用 `Write-Host` 收集控制台输出）
- 相关辅助脚本与工具位于 `scripts/` 目录。
- 日志输出在 `logs/` 目录，便于调试。

## 项目约定与模式
- 按键映射与模式切换高度模块化，便于扩展新模式或窗口类型。
- 按键映射采用类似 Vim 的 map 语法，支持多种参数与组合。
- 代码注释多为中文，建议保持风格一致。
- 重要模式/窗口配置示例见 `wins/General/General.ahk`。
- 外部依赖如 `Komorebic.exe`、`kanata-gui.exe` 通过 `Run()` 调用。

## 参考文件
- `README.md`：架构简述与设计理念。
- `CLAUDE.md`：AI 代码助手协作说明。
- `wins/` 目录：各窗口类型的具体配置与扩展。
- `lib/` 目录：第三方或自定义库。

## 其他说明
- 当前无自动化测试、CI/CD 或格式化工具。
- 没有 Copilot/Cursor 规则文件。
- 代码风格以可读性和可维护性为主，优先保持现有结构。

---

如需扩展新模式、窗口或按键映射，请参考现有类与 `wins/` 目录下的实现范式。
