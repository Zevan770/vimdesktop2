/** @type {VimDWindow} */
; win := vimd.initWin("vscode", "ahk_exe code.exe")
TEST_GROUP := "test_group"
GroupAdd(TEST_GROUP, "ahk_exe code.exe")
GroupAdd(TEST_GROUP, "ahk_exe code - insiders.exe")
GroupAdd(TEST_GROUP, "ahk_exe systeminformer.exe")
win := VimD.initWin("vscode", "ahk_group " TEST_GROUP)
win.keyToNormal := "F1"
win.keyToInsert := "F2"
/** @type {VimDMode} */
mode := win.initMode(1, , "normal", 0)
mode.onBeforeKey := (p*) => (
    WinActive("ahk_exe code.exe") ?
        mode.BeforeKeyUIA()
    : mode.BeforeKey()
)