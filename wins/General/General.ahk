#Include <lxiko\ConfOverride>
RestartKanata() {
    ProcessClose("kanata-gui.exe")
    Run("kanata-gui.exe --port 4039 --nodelay", , "Hide")
}

RestartKanata()

/** @type {VimDWindow} */
win := VimD.initWin("General", "A")
win.keyToMode1 := "F1"
win.keyToMode0 := "F2"
/** @type {VimDMode} */
mode1 := win.initMode(1, , "normal", 3)

BindLogger(lhs) {
    mode1.MapKey(lhs, ObjBindMethod(logger, "info", "typed " lhs), "msgbox")
}
; BindLogger(">!e j")
; BindLogger(">!e k k")
; BindLogger(">!e -")

; #region test left/right/not-specifying modifyier priority
BindLogger("!a")
BindLogger(">!a")
BindLogger(">!b")
BindLogger("!b")

; type >!a >!b
; => trigger >!a >!b
; CONCLUSION: modifier priority: specifying left/right has higher priority than not specifying
; #endregion

; #region test priority of definition order
BindLogger("!c")
mode1.MapKey("!c", ObjBindMethod(logger, "info", "typed !c second"), "msgbox")

; type !c
; => trigger second defined !c
; CONCLUSION: 同一个Hotif, 后定义的优先级更高
; IMPORTANT: This CONCLUSION has a premise: the two definitions have the same Hotif context
; #endregion

; mode1.MapKey("j j", ObjBindMethod(logger, "info", "typed j j"), "msgbox")

/** @type {VimDWindow} */
win1 := VimD.initWin("General1", "A")
win1.keyToMode1 := "F1"
win1.keyToMode0 := "F2"
/** @type {VimDMode} */
mode11 := win1.initMode(1, , "normal", 3)

BindLogger1(lhs) {
    mode11.MapKey(lhs, ObjBindMethod(logger, "info", "typed in win1 " lhs), "msgbox")
}

; #region test window priority
BindLogger("!d")
BindLogger1("!d")
; triggers win
BindLogger1("!m")
BindLogger("!m")
; triggers win1
; CONCLUSION: `key 后定义优先级更高` 规则 比 `Hotif 最早` 规则 优先级更高
; #endregion

; #region test window priority1 with complex left/right/not-specifying modifyier
BindLogger("!e")
BindLogger1(">!e")
BindLogger1(">!f")
BindLogger("!f")
; both triggers win1
BindLogger(">!g")
BindLogger1("!g")
BindLogger1("!h")
BindLogger(">!h")
; both triggers win
; CONCLUSION: `左右>不指定` 规则 比 `Hotif 最早` 规则 优先级更高
; #endregion


; 几个规则
; - mode 的定义先后(或者说，hotif 的定义先后)
; - key 的定义先后
; - 指定左右与不指定
