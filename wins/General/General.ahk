#Include <ToggleDarkTheme>

RestartKanata() {
    if (ProcessExist("kanata-gui.exe")) {
        ProcessClose("kanata-gui.exe")
    }
    Run("kanata-gui.exe --port 4039 --nodelay", , "Hide")
}
RestartKanata()


win := VimD.initWin("General", "")
win.keyToNormal := ""
win.keyToInsert := ""


; #region komorebi

win.initMode(2, , "normal", 0)
/** @type {VimDMode} */
mode := win.SwitchMode(2)
modeK := win.initMode(3, , "komorebi", 3)

VimDMode_MapKomorebic(this, key, args, withQuit := true) {
    KomoRun() {
        Run("Komorebic.exe " args, , "Hide")
        if (withQuit)
            win.SwitchMode(2)
    }
    this.MapKey(key, KomoRun, "Komo" args)
}
VimDMode.Prototype.MapKomorebic := VimDMode_MapKomorebic

; #region win-vind
; RestartWinVind() {
;     if (ProcessExist("win-vind.exe")) {
;         ProcessClose("win-vind.exe")
;     }
; }

; RestartWinVind()
; VimDMode_MapWinVind(this, key, args) {
;     WinVindRun() {
;         Run("win-vind -c " args, , "Hide")
;     }
;     this.MapKey(key, WinVindRun, "WinVind" args)
; }
; VimDMode.Prototype.MapWinVind := VimDMode_MapWinVind
; mode.MapWinVind("<!f", "<easyclick><click_left>")
; #endregion


mode.MapKomorebic("<!h", "focus left")
mode.MapKomorebic("<!j", "focus down")
mode.MapKomorebic("<!k", "focus up")
mode.MapKomorebic("<!l", "focus right")
mode.MapKomorebic("<!p", "cycle-stack previous")
mode.MapKomorebic("<!n", "cycle-stack next")
mode.MapKomorebic("<![", "cycle-workspace previous", false)
mode.MapKomorebic("<!]", "cycle-workspace next", false)
mode.MapKomorebic("<!t", "focus-last-workspace")

; resize
mode.MapKomorebic("<!+h", "resize-axis horizontal decrease")
mode.MapKomorebic("<!+j", "resize-axis vertical decrease")
mode.MapKomorebic("<!+k", "resize-axis vertical increase")
mode.MapKomorebic("<!+l", "resize-axis horizontal increase")
mode.MapKey("<!e r", Reload, "reload")
mode.MapKey("<!e t", ToggleSystemTheme, "toggle-theme")
; 工作区切换
loop 9
{
    mode.MapKomorebic("Numpad" A_Index, "focus-workspace " A_Index - 1)
}

; 最大化/浮动/忽略
mode.MapKomorebic("<!z", "toggle-maximize")
mode.MapKomorebic("<!a", "toggle-float")

KomoAndTip(*) {
    win.SwitchMode(3)
    modeK.ShowTips(modeK.actionManager.GetActionsStartingWith(modeK.keySeq))
}

mode.MapKey("<!w", KomoAndTip, "komoMode")

; komorebi模式下常用按键
modeK.MapKey("esc", ObjBindMethod(win, "SwitchMode", 2), "normalMode")
modeK.MapKey("space", ObjBindMethod(win, "SwitchMode", 2), "normalMode")
; send/move to workspace
loop 9
{
    modeK.MapKomorebic("Numpad" A_Index, "focus-workspace " A_Index - 1)
    modeK.MapKomorebic("^Numpad" A_Index, "move-to-workspace " A_Index - 1)
    modeK.MapKomorebic("s " A_Index, "send-to-workspace " A_Index - 1)
}
modeK.MapKomorebic("s h", "stack left", false)
modeK.MapKomorebic("s j", "stack down", false)
modeK.MapKomorebic("s k", "stack up", false)
modeK.MapKomorebic("s l", "stack right", false)
modeK.MapKomorebic("s u", "unstack")
modeK.MapKomorebic("s a", "stack-all")
modeK.MapKomorebic("s q", "unstack-all")
modeK.MapKomorebic("[", "cycle-workspace previous", false)
modeK.MapKomorebic("]", "cycle-workspace next", false)
modeK.MapKomorebic("^[", "cycle-move-to-workspace previous", false)
modeK.MapKomorebic("^]", "cycle-move-to-workspace next", false)

; 其它常用
modeK.MapKomorebic("m", "cycle-stack previous", false)
modeK.MapKomorebic(",", "cycle-stack next", false)
modeK.MapKomorebic("; p", "toggle-pause")
modeK.MapKomorebic("; g", "gui")
modeK.MapKomorebic("; x", "stop")
modeK.MapKomorebic("; n", "cycle-layout next", false)
modeK.MapKomorebic("; p", "cycle-layout previous", false)
modeK.MapKomorebic("c", "minimize")
; 最大化/浮动/忽略
modeK.MapKomorebic("z", "toggle-maximize")
modeK.MapKomorebic("a", "toggle-float")
modeK.MapKomorebic("h", "focus left", false)
modeK.MapKomorebic("j", "focus down", false)
modeK.MapKomorebic("k", "focus up", false)
modeK.MapKomorebic("l", "focus right", false)
modeK.MapKomorebic("q", "close", false)
modeK.MapKomorebic("t", "focus-last-workspace")
modeK.MapKomorebic("p", "cycle-stack previous", false)
modeK.MapKomorebic("n", "cycle-stack next", false)
modeK.MapKomorebic("+h", "resize-axis horizontal decrease", false)
modeK.MapKomorebic("+j", "resize-axis vertical decrease", false)
modeK.MapKomorebic("+k", "resize-axis vertical increase", false)
modeK.MapKomorebic("+l", "resize-axis horizontal increase", false)
modeK.MapKomorebic("^h", "move left", false)
modeK.MapKomorebic("^j", "move down", false)
modeK.MapKomorebic("^k", "move up", false)
modeK.MapKomorebic("^l", "move right", false)

; modeK.MapKomorebic("]", "cycle-monitor next")
; modeK.MapKomorebic("^]", "cycle-move-to-monitor previous")
; #endregion
