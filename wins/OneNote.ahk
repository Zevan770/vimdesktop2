Class WinOneNote {
    __New() {
        win := VimD.initWin("OneNote", "ahk_exe ONENOTE.exe")

        win.keyToNormal := ""
        win.keyToInsert := ""

        mode := win.initMode(2)
        win.SwitchMode(2)

        mode.MapKey("+WheelUp", () => Send("{WheelLeft}"))
        mode.MapKey("+WheelDown", () => Send("{WheelRight}"))
    }
}

WinOneNote()
