#Requires AutoHotkey v2.0.2

class Komorebi {
    /**
     * 
     * @param args - komorebi.exe 的参数
     * @param wait - 是否等待命令完成
     */
    Run(args, wait := false) {
        if (wait) {
            RunWait("komorebic.exe " args, , "Hide")
        } else {
            Run("komorebic.exe " args, , "Hide")
        }
    }

    Gui(wait := false) {
        this.Run("gui", wait)
    }

    ; 启动 komorebi.exe 作为后台进程
    Start(wait := false) {
        this.Run("start ", wait)
        ; Run("komorebic.exe start " ffm " --await-configuration " await_configuration " --tcp-port " tcp_port, ,
        ;     "Hide")
    }

    ; 停止 komorebi.exe 进程并恢复所有隐藏的窗口
    Stop(wait := false) {
        this.Run("stop", wait)
    }

    ; 显示当前窗口管理器状态的 JSON 表示
    State(wait := false) {
        Run("wezterm-gui.exe start --domain Arch -- zsh -c `"komorebic.exe state | bat -l json`"")
        ; Run("wezterm-gui.exe start --domain Arch -- zsh")
    }

    ; 查询当前窗口管理器状态
    Query(state_query, wait := false) {
        this.Run("query " state_query, wait)
    }

    Subscribe(named_pipe, wait := false) {
        this.Run("subscribe " named_pipe, wait)
    }

    ; 取消订阅 komorebi 事件
    Unsubscribe(named_pipe, wait := false) {
        this.Run("unsubscribe " named_pipe, wait)
    }

    ; 跟踪 komorebi.exe 的进程日志
    Log(wait := false) {
        this.Run("log", wait)
    }

    ; 快速保存当前调整大小的布局尺寸
    QuickSaveResize(wait := false) {
        this.Run("quick-save-resize", wait)
    }

    ; 加载最后一次快速保存的调整大小的布局尺寸
    QuickLoadResize(wait := false) {
        this.Run("quick-load-resize", wait)
    }

    ; 保存当前调整大小的布局尺寸到文件
    SaveResize(path, wait := false) {
        this.Run("save-resize " path, wait)
    }

    ; 从文件加载调整大小的布局尺寸
    LoadResize(path, wait := false) {
        this.Run("load-resize " path, wait)
    }

    ; 将焦点更改到指定方向的窗口
    Focus(operation_direction, wait := false) {
        this.Run("focus " operation_direction, wait)
    }

    ; 将焦点窗口移动到指定方向
    Move(operation_direction, wait := false) {
        this.Run("move " operation_direction, wait)
    }

    ; 最小化焦点窗口
    Minimize(wait := false) {
        this.Run("minimize", wait)
    }

    ; 关闭焦点窗口
    Close(wait := false) {
        this.Run("close", wait)
    }

    ; 强制将焦点设置到光标所在的窗口
    ForceFocus(wait := false) {
        this.Run("force-focus", wait)
    }

    ; 将焦点更改到指定循环方向的窗口
    CycleFocus(cycle_direction, wait := false) {
        this.Run("cycle-focus " cycle_direction, wait)
    }

    ; 将焦点窗口移动到指定循环方向
    CycleMove(cycle_direction, wait := false) {
        this.Run("cycle-move " cycle_direction, wait)
    }

    ; 将焦点窗口堆叠到指定方向
    Stack(operation_direction, wait := false) {
        this.Run("stack " operation_direction, wait)
    }

    /**
     * 调整焦点窗口的大小
     * @param {string} edge - 要调整大小的边
     * @param {string} sizing - 减小或增大
     */
    Resize(edge, sizing, wait := false) {
        this.Run("resize " edge " " sizing, wait)
    }

    ; 沿指定轴调整焦点窗口或主列的大小
    ResizeAxis(axis, sizing, wait := false) {
        this.Run("resize-axis " axis " " sizing, wait)
    }

    ; 取消堆叠焦点窗口
    Unstack(wait := false) {
        this.Run("unstack", wait)
    }

    ; 将焦点堆栈更改到指定循环方向
    CycleStack(cycle_direction, wait := false) {
        this.Run("cycle-stack " cycle_direction, wait)
    }

    ; 将焦点窗口移动到指定监视器
    MoveToMonitor(target, wait := false) {
        this.Run("move-to-monitor " target, wait)
    }

    ; 将焦点窗口移动到指定循环方向的监视器
    CycleMoveToMonitor(cycle_direction, wait := false) {
        this.Run("cycle-move-to-monitor " cycle_direction, wait)
    }

    ; 将焦点窗口移动到指定工作区
    MoveToWorkspace(target, wait := false) {
        this.Run("move-to-workspace " target, wait)
    }

    MoveToNamedWorkspace(workspace, wait := false) {
        this.Run("move-to-named-workspace " workspace, wait)
    }

    ; 将焦点窗口移动到指定循环方向的工作区
    CycleMoveToWorkspace(cycle_direction, wait := false) {
        this.Run("cycle-move-to-workspace " cycle_direction, wait)
    }

    ; 将焦点窗口发送到指定监视器
    SendToMonitor(target, wait := false) {
        this.Run("send-to-monitor " target, wait)
    }

    ; 将焦点窗口发送到指定循环方向的监视器
    CycleSendToMonitor(cycle_direction, wait := false) {
        this.Run("cycle-send-to-monitor " cycle_direction, wait)
    }

    ; 将焦点窗口发送到指定工作区
    SendToWorkspace(target, wait := false) {
        this.Run("send-to-workspace " target, wait)
    }

    ; 将焦点窗口发送到指定命名工作区
    SendToNamedWorkspace(workspace, wait := false) {
        this.Run("send-to-named-workspace " workspace, wait)
    }

    ; 将焦点窗口发送到指定循环方向的工作区
    CycleSendToWorkspace(cycle_direction, wait := false) {
        this.Run("cycle-send-to-workspace " cycle_direction, wait)
    }

    ; 将焦点窗口发送到指定监视器工作区
    SendToMonitorWorkspace(target_monitor, target_workspace, wait := false) {
        this.Run("send-to-monitor-workspace " target_monitor " " target_workspace, wait)
    }

    ; 将焦点设置到指定监视器
    FocusMonitor(target, wait := false) {
        this.Run("focus-monitor " target, wait)
    }

    FocusLastWorkspace(wait := false) {
        this.Run("focus-last-workspace", wait)
    }

    ; 将焦点设置到指定工作区
    FocusWorkspace(target, wait := false) {
        this.Run("focus-workspace " target, wait)
    }

    ; 将焦点设置到目标监视器的指定工作区
    FocusMonitorWorkspace(target_monitor, target_workspace, wait := false) {
        this.Run("focus-monitor-workspace " target_monitor " " target_workspace, wait)
    }

    ; 将焦点设置到指定命名工作区
    FocusNamedWorkspace(workspace, wait := false) {
        this.Run("focus-named-workspace " workspace, wait)
    }

    ; 将焦点设置到指定循环方向的监视器
    CycleMonitor(cycle_direction, wait := false) {
        this.Run("cycle-monitor " cycle_direction, wait)
    }

    ; 将焦点设置到指定循环方向的工作区
    CycleWorkspace(cycle_direction, wait := false) {
        this.Run("cycle-workspace " cycle_direction, wait)
    }

    ; 将焦点工作区移动到指定监视器
    MoveWorkspaceToMonitor(target, wait := false) {
        this.Run("move-workspace-to-monitor " target, wait)
    }

    ; 创建并附加一个新的工作区到焦点监视器
    NewWorkspace(wait := false) {
        this.Run("new-workspace", wait)
    }

    ; 设置调整大小的增量（用于 resize-edge 和 resize-axis）
    ResizeDelta(pixels, wait := false) {
        this.Run("resize-delta " pixels, wait)
    }

    ; 设置每个窗口周围的不可见边框尺寸
    InvisibleBorders(left, top, right, bottom, wait := false) {
        this.Run("invisible-borders " left " " top " " right " " bottom, wait)
    }

    ; 设置全局工作区偏移量以排除部分工作区区域
    GlobalWorkAreaOffset(left, top, right, bottom, wait := false) {
        this.Run("global-work-area-offset " left " " top " " right " " bottom, wait)
    }

    ; 设置监视器的工作区偏移量以排除部分工作区区域
    MonitorWorkAreaOffset(monitor, left, top, right, bottom, wait := false) {
        this.Run("monitor-work-area-offset " monitor " " left " " top " " right " " bottom, wait)
    }

    ; 调整焦点工作区的容器填充
    AdjustContainerPadding(sizing, adjustment, wait := false) {
        this.Run("adjust-container-padding " sizing " " adjustment, wait)
    }

    ; 调整焦点工作区的工作区填充
    AdjustWorkspacePadding(sizing, adjustment, wait := false) {
        this.Run("adjust-workspace-padding " sizing " " adjustment, wait)
    }

    ChangeLayout(default_layout, wait := false) {
        this.Run("change-layout " default_layout, wait)
    }

    ; 在可用布局之间循环
    CycleLayout(operation_direction, wait := false) {
        this.Run("cycle-layout " operation_direction, wait)
    }

    ; 从文件加载自定义布局到焦点工作区
    LoadCustomLayout(path, wait := false) {
        this.Run("load-custom-layout " path, wait)
    }

    ; 翻转焦点工作区的布局（仅限 BSP）
    FlipLayout(axis, wait := false) {
        this.Run("flip-layout " axis, wait)
    }

    ; 将焦点窗口提升到树的顶部
    Promote(wait := false) {
        this.Run("promote", wait)
    }

    ; 将用户焦点提升到树的顶部
    PromoteFocus(wait := false) {
        this.Run("promote-focus", wait)
    }

    ; 强制重新排列所有管理的窗口
    Retile(wait := false) {
        this.Run("retile", wait)
    }

    ; 设置监视器的索引偏好
    MonitorIndexPreference(index_preference, left, top, right, bottom, wait := false) {
        Run("komorebic.exe monitor-index-preference " index_preference " " left " " top " " right " " bottom, ,
            "Hide")
    }

    ; 为指定监视器创建至少这么多工作区
    EnsureWorkspaces(monitor, workspace_count, wait := false) {
        this.Run("ensure-workspaces " monitor " " workspace_count, wait)
    }

    ; 为指定监视器创建这些命名工作区
    EnsureNamedWorkspaces(monitor, names, wait := false) {
        this.Run("ensure-named-workspaces " monitor " " names, wait)
    }

    ; 设置指定工作区的容器填充
    ContainerPadding(monitor, workspace, size, wait := false) {
        this.Run("container-padding " monitor " " workspace " " size, wait)
    }

    ; 设置指定命名工作区的容器填充
    NamedWorkspaceContainerPadding(workspace, size, wait := false) {
        this.Run("named-workspace-container-padding " workspace " " size, wait)
    }

    ; 设置指定工作区的工作区填充
    WorkspacePadding(monitor, workspace, size, wait := false) {
        this.Run("workspace-padding " monitor " " workspace " " size, wait)
    }

    ; 设置指定命名工作区的工作区填充
    NamedWorkspacePadding(workspace, size, wait := false) {
        this.Run("named-workspace-padding " workspace " " size, wait)
    }

    ; 设置指定工作区的布局
    WorkspaceLayout(monitor, workspace, value, wait := false) {
        this.Run("workspace-layout " monitor " " workspace " " value, wait)
    }

    ; 设置指定命名工作区的布局
    NamedWorkspaceLayout(workspace, value, wait := false) {
        this.Run("named-workspace-layout " workspace " " value, wait)
    }

    ; 为指定工作区从文件加载自定义布局
    WorkspaceCustomLayout(monitor, workspace, path, wait := false) {
        this.Run("workspace-custom-layout " monitor " " workspace " " path, wait)
    }

    ; 为指定命名工作区从文件加载自定义布局
    NamedWorkspaceCustomLayout(workspace, path, wait := false) {
        this.Run("named-workspace-custom-layout " workspace " " path, wait)
    }

    ; 为指定工作区添加动态布局规则
    WorkspaceLayoutRule(monitor, workspace, at_container_count, layout, wait := false) {
        Run("komorebic.exe workspace-layout-rule " monitor " " workspace " " at_container_count " " layout, ,
            "Hide")
    }

    ; 为指定命名工作区添加动态布局规则
    NamedWorkspaceLayoutRule(workspace, at_container_count, layout, wait := false) {
        this.Run("named-workspace-layout-rule " workspace " " at_container_count " " layout, wait)
    }

    ; 为指定工作区添加动态自定义布局
    WorkspaceCustomLayoutRule(monitor, workspace, at_container_count, path, wait := false) {
        this.Run("workspace-custom-layout-rule " monitor " " workspace " " at_container_count " " path, wait)
    }

    ; 为指定命名工作区添加动态自定义布局
    NamedWorkspaceCustomLayoutRule(workspace, at_container_count, path, wait := false) {
        this.Run("named-workspace-custom-layout-rule " workspace " " at_container_count " " path, wait)
    }

    ; 清除指定工作区的所有动态布局规则
    ClearWorkspaceLayoutRules(monitor, workspace, wait := false) {
        this.Run("clear-workspace-layout-rules " monitor " " workspace, wait)
    }

    ; 清除指定命名工作区的所有动态布局规则
    ClearNamedWorkspaceLayoutRules(workspace, wait := false) {
        this.Run("clear-named-workspace-layout-rules " workspace, wait)
    }

    ; 启用或禁用指定工作区的窗口平铺
    WorkspaceTiling(monitor, workspace, value, wait := false) {
        this.Run("workspace-tiling " monitor " " workspace " " value, wait)
    }

    ; 启用或禁用指定命名工作区的窗口平铺
    NamedWorkspaceTiling(workspace, value, wait := false) {
        this.Run("named-workspace-tiling " workspace " " value, wait)
    }

    ; 设置指定工作区的名称
    WorkspaceName(monitor, workspace, value, wait := false) {
        this.Run("workspace-name " monitor " " workspace " " value, wait)
    }

    ; 切换新窗口的行为（堆叠或动态平铺）
    ToggleWindowContainerBehaviour(wait := false) {
        this.Run("toggle-window-container-behaviour", wait)
    }

    ; 切换焦点工作区的窗口平铺
    TogglePause(wait := false) {
        this.Run("toggle-pause", wait)
    }

    ; 切换焦点工作区的窗口平铺
    ToggleTiling(wait := false) {
        this.Run("toggle-tiling", wait)
    }

    ; 切换焦点窗口的浮动模式
    ToggleFloat(wait := false) {
        this.Run("toggle-float", wait)
    }

    ; 切换焦点容器的单片模式
    ToggleMonocle(wait := false) {
        this.Run("toggle-monocle", wait)
    }

    ; 切换焦点窗口的本地最大化
    ToggleMaximize(wait := false) {
        this.Run("toggle-maximize", wait)
    }

    ; 恢复所有隐藏的窗口（调试命令）
    RestoreWindows(wait := false) {
        this.Run("restore-windows", wait)
    }

    ; 强制 komorebi 管理焦点窗口
    Manage(wait := false) {
        this.Run("manage", wait)
    }

    ; 取消管理被强制管理的窗口
    Unmanage(wait := false) {
        this.Run("unmanage", wait)
    }

    ; 重新加载配置
    ReloadConfiguration(wait := false) {
        this.Run("reload-configuration", wait)
    }

    ; 启用或禁用对配置文件的监视
    WatchConfiguration(boolean_state, wait := false) {
        this.Run("watch-configuration " boolean_state, wait)
    }

    ; 完成配置
    CompleteConfiguration(wait := false) {
        this.Run("complete-configuration", wait)
    }

    ; 切换 Alt 焦点黑客
    AltFocusHack(boolean_state, wait := false) {
        this.Run("alt-focus-hack " boolean_state, wait)
    }

    ; 设置窗口隐藏行为
    WindowHidingBehaviour(hiding_behaviour, wait := false) {
        this.Run("window-hiding-behaviour " hiding_behaviour, wait)
    }

    ; 设置跨监视器移动行为
    CrossMonitorMoveBehaviour(move_behaviour, wait := false) {
        this.Run("cross-monitor-move-behaviour " move_behaviour, wait)
    }

    ; 切换跨监视器移动行为
    ToggleCrossMonitorMoveBehaviour(wait := false) {
        this.Run("toggle-cross-monitor-move-behaviour", wait)
    }

    ; 设置未管理窗口的操作行为
    UnmanagedWindowOperationBehaviour(operation_behaviour, wait := false) {
        this.Run("unmanaged-window-operation-behaviour " operation_behaviour, wait)
    }

    ; 添加规则以始终浮动指定应用程序
    FloatRule(identifier, id, wait := false) {
        this.Run("float-rule " identifier " `"" id "`"", wait)
    }

    ; 添加规则以始终管理指定应用程序
    ManageRule(identifier, id, wait := false) {
        this.Run("manage-rule " identifier " `"" id "`"", wait)
    }

    ; 添加规则以将应用程序与指定监视器和工作区关联
    WorkspaceRule(identifier, id, monitor, workspace, wait := false) {
        this.Run("workspace-rule " identifier " `"" id "`" " monitor " " workspace, wait)
    }

    ; 添加规则以将应用程序与指定命名工作区关联
    NamedWorkspaceRule(identifier, id, workspace, wait := false) {
        this.Run("named-workspace-rule " identifier " `"" id "`" " workspace, wait)
    }

    ; 识别在启动时发送 EVENT_OBJECT_NAMECHANGE 的应用程序
    IdentifyObjectNameChangeApplication(identifier, id, wait := false) {
        this.Run("identify-object-name-change-application " identifier " `"" id "`"", wait)
    }

    ; 识别关闭到系统托盘的应用程序
    IdentifyTrayApplication(identifier, id, wait := false) {
        this.Run("identify-tray-application " identifier " `"" id "`"", wait)
    }

    ; 识别具有 WS_EX_LAYERED 但仍应管理的应用程序
    IdentifyLayeredApplication(identifier, id, wait := false) {
        this.Run("identify-layered-application " identifier " `"" id "`"", wait)
    }

    ; 识别边框溢出的应用程序
    IdentifyBorderOverflowApplication(identifier, id, wait := false) {
        this.Run("identify-border-overflow-application " identifier " `"" id "`"", wait)
    }

    ; 启用或禁用活动窗口边框
    ActiveWindowBorder(boolean_state, wait := false) {
        this.Run("active-window-border " boolean_state, wait)
    }

    ; 设置活动窗口边框颜色
    ActiveWindowBorderColour(r, g, b, window_kind, wait := false) {
        this.Run("active-window-border-colour " r " " g " " b " --window-kind " window_kind, wait)
    }

    ; 设置活动窗口边框宽度
    ActiveWindowBorderWidth(width, wait := false) {
        this.Run("active-window-border-width " width, wait)
    }

    ; 设置活动窗口边框偏移量
    ActiveWindowBorderOffset(offset, wait := false) {
        this.Run("active-window-border-offset " offset, wait)
    }

    ; 启用或禁用鼠标跟随焦点
    FocusFollowsMouse(boolean_state, implementation, wait := false) {
        this.Run("focus-follows-mouse " boolean_state " --implementation " implementation, wait)
    }

    ; 切换鼠标跟随焦点
    ToggleFocusFollowsMouse(implementation, wait := false) {
        this.Run("toggle-focus-follows-mouse  --implementation " implementation, wait)
    }

    ; 启用或禁用焦点跟随鼠标
    MouseFollowsFocus(boolean_state, wait := false) {
        this.Run("mouse-follows-focus " boolean_state, wait)
    }

    ; 切换焦点跟随鼠标
    ToggleMouseFollowsFocus(wait := false) {
        this.Run("toggle-mouse-follows-focus", wait)
    }

    ; 生成用于 komorebi.ahk 的常见应用程序特定配置和修复
    AhkLibrary(wait := false) {
        this.Run("ahk-library", wait)
    }

    ; 生成用于 komorebi.ahk 的应用程序特定配置和修复
    AhkAppSpecificConfiguration(path, override_path, wait := false) {
        this.Run("ahk-app-specific-configuration " path " " override_path, wait)
    }

    ; 生成用于 PowerShell 脚本的应用程序特定配置和修复
    PwshAppSpecificConfiguration(path, override_path, wait := false) {
        this.Run("pwsh-app-specific-configuration " path " " override_path, wait)
    }

    ; 格式化 YAML 文件以用于 'ahk-app-specific-configuration' 命令
    FormatAppSpecificConfiguration(path, wait := false) {
        this.Run("format-app-specific-configuration " path, wait)
    }

    ; 生成订阅通知的 JSON Schema
    NotificationSchema(wait := false) {
        this.Run("notification-schema", wait)
    }

    ; 生成套接字消息的 JSON Schema
    SocketSchema(wait := false) {
        this.Run("socket-schema", wait)
    }

    KillAndReload(wait := false) {
        if ProcessExist("yasb.exe") {
            ProcessClose("yasb.exe")
        }
        this.Stop(true)
        if ProcessExist("komokana.exe") {
            ProcessClose("komokana.exe")
        }
        if ProcessExist("komorebi.exe") {
            ProcessClose("komorebi.exe")
        }

        RunWait("yasbc.exe start", , "Hide")
        this.Start(true)
        ; Run("komokana.exe -t --kanata-port 8613 --default-layer base", , "Hide")
    }
}
