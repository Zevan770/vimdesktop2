RestartKanata() {
    ProcessClose("kanata-gui.exe")
    Run("kanata-gui.exe --port 8613", , "Hide")
}

RestartKanata()

/** @type {VimDWindow} */
win := vimd.initWin("General", "A")
win.keyToMode1 := "F1"
win.keyToMode0 := "F2"
/** @type {VimDMode} */
mode1 := win.initMode(1, , "normal", 3)
mode1.MapKey(">!e j", ObjBindMethod(logger, "info", "typed >!e j"), "msgbox")
mode1.MapKey(">!e k k", ObjBindMethod(logger, "info", "typed >!e k k"), "msgbox")
mode1.MapKey(">!e -", ObjBindMethod(logger, "info", "typed >!e -"), "msgbox")
; mode1.MapKey("j j", ObjBindMethod(logger, "info", "typed j j"), "msgbox")
