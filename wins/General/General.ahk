RestartKanata() {
    ProcessClose("kanata-gui.exe")
    Run("kanata-gui.exe --port 4039 --nodelay", , "Hide")
}

RestartKanata()

win := VimD.initWin("General", "A")
win.keyToMode1 := "F1"
win.keyToMode0 := "F2"
/** @type {VimDMode} */
mode0 := win.initMode(1, , "normal", 3)