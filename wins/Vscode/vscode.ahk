/** @type {VimDWindow} */
; win := vimd.initWin("vscode", "ahk_exe code.exe")
TEST_GROUP := "test_group"
GroupAdd(TEST_GROUP, "ahk_exe code.exe")
GroupAdd(TEST_GROUP, "ahk_exe code - insiders.exe")
GroupAdd(TEST_GROUP, "ahk_exe systeminformer.exe")
win := VimD.initWin("vscode", "ahk_group " TEST_GROUP)
win.keyToMode1 := "F1"
win.keyToMode0 := "F2"
/** @type {VimDMode} */
mode0 := win.initMode(1, , "normal", 3)
; mode1.MapKey("- =", ObjBindMethod(logger, "info", "typed - ="), "msgbox")
mode0.onBeforeKey := (p*) => (
    WinActive("ahk_exe code.exe") ?
        mode0.BeforeKeyUIA()
    : mode0.BeforeKey()
)