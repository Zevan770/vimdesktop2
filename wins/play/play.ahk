Class WinPlay {
    /* @type {VimDWindow} */
    win := {}

    __New() {
        win := VimD.initWin("Play", "ahk_exe MuMuNxDevice.exe")

        win.keyToNormal := ""
        win.keyToInsert := ""

        mode := win.initMode(2, , "normal", 0)
        win.SwitchMode(2)

        mode.MapKey("3", Send.Bind("{LButton Down}"), "")
        mode.MapKey("^+3", Send.Bind("3"), "")
    }
}

WinPlay()
