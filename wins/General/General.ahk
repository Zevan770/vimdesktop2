#Include <ToggleDarkTheme>

logger.level := LogLevel.INFO
logger.is_out_console := false
logger.is_out_file := true

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

mode := win.initMode(2, , "normal", 0)
/** @type {VimDMode} */
win.SwitchMode(2)
modeK := win.initMode(3, , "komorebi", 0)

VimDMode_MapKomorebic(this, key, args, withQuit := true) {
    KomoRun() {
        Run("komorebic.exe " args, , "Hide")
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

mode.MapKomorebic("<!t", "focus-last-workspace")
mode.MapKomorebic("<!q", "close")
mode.MapKomorebic("<!c", "minimize")
; 最大化/浮动/忽略
mode.MapKomorebic("<!z", "toggle-maximize")
mode.MapKomorebic("<!a", "toggle-float")
mode.MapKomorebic("<!p", "cycle-stack previous")
mode.MapKomorebic("<!n", "cycle-stack next")

; move
mode.MapKomorebic("<!^h", "move left")
mode.MapKomorebic("<!^l", "move right")
mode.MapKomorebic("<!^j", "cycle-move-to-workspace next")
mode.MapKomorebic("<!^k", "cycle-move-to-workspace previous")

; resize
mode.MapKomorebic("<!+h", "resize-axis horizontal decrease")
mode.MapKomorebic("<!+l", "resize-axis horizontal increase")

; stack send
mode.MapKomorebic("<!>!h", "stack left")
mode.MapKomorebic("<!>!l", "stack right")
mode.MapKomorebic("<!>!j", "cycle-send-to-workspace next")
mode.MapKomorebic("<!>!k", "cycle-send-to-workspace previous")
mode.MapKomorebic("<!>!u", "unstack")
mode.MapKomorebic("<!>!o", "stack-all")

mode.MapKomorebic("<!h", "focus left")
mode.MapKomorebic("<!l", "focus right")
mode.MapKomorebic("<!j", "cycle-workspace next")
mode.MapKomorebic("<!k", "cycle-workspace previous")

mode.MapKey("<!e g", WinToggleTopAndTransparent, "toggle-always-on-top")
mode.MapKomorebic("<!e a", "session-float-rule")

mode.MapKomorebic("<!WheelUp", "cycle-workspace previous", false)
mode.MapKomorebic("<!WheelDown", "cycle-workspace next", false)
mode.MapKomorebic("<!^WheelUp", "cycle-move-to-workspace previous", false)
mode.MapKomorebic("<!^WheelDown", "cycle-move-to-workspace next", false)

WinToggleTopAndTransparent() {
    WinSetTransparent(WinGetAlwaysOnTop("A") ? 255 : 198, "A")
    WinSetAlwaysOnTop(-1, "A")
}

mode.MapKey("<!e r", Reload, "reload")
mode.MapKey("<!e t", ToggleSystemTheme, "toggle-theme")
mode.MapKey("<!e s", () => (RunHide("flameshot.exe gui")), "toggle-theme")
; 工作区切换
loop 9 {
    mode.MapKomorebic("<!" A_Index, "focus-workspace " A_Index - 1)
    mode.MapKomorebic("<!^" A_Index, "move-to-workspace " A_Index - 1)
}

KomoAndTip(*) {
    win.SwitchMode(3)
    modeK.ShowTips(modeK.actionManager.GetActionsStartingWith(modeK.keySeq))
}

mode.MapKey("<!w", KomoAndTip, "komoMode")

modeK.MapKey("esc", ObjBindMethod(win, "SwitchMode", 2), "normalMode")
modeK.MapKey("space", ObjBindMethod(win, "SwitchMode", 2), "normalMode")
; send/move to workspace
loop 9 {
    modeK.MapKomorebic(String(A_Index), "focus-workspace " A_Index - 1, false)
    modeK.MapKomorebic("^" A_Index, "move-to-workspace " A_Index - 1, false)
    modeK.MapKomorebic("s " A_Index, "send-to-workspace " A_Index - 1, false)
}
RestartKomorebi() {
    Run("cmd /C komorebic.exe stop && komorebic start", , "Hide")
}
modeK.MapKey("r", RestartKomorebi, "restart")

; 其它常用
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
modeK.MapKomorebic(">!h", "stack left")
modeK.MapKomorebic(">!l", "stack right")
modeK.MapKomorebic("u", "unstack", false)
modeK.MapKomorebic("k", "cycle-workspace previous", false)
modeK.MapKomorebic("j", "cycle-workspace next", false)
modeK.MapKomorebic("^k", "cycle-move-to-workspace previous", false)
modeK.MapKomorebic("^j", "cycle-move-to-workspace next", false)

; modeK.MapKomorebic("]", "cycle-monitor next")
; modeK.MapKomorebic("^]", "cycle-move-to-monitor previous")
; #endregion
