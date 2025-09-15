#Include <lxiko\ConfOverride>

RestartKanata() {
    ProcessClose("kanata-gui.exe")
    Run("kanata-gui.exe --port 4039 --nodelay", , "Hide")
}

RestartKanata()

; ---- VimD优先级全变量穷举测试，每组都成对交换定义顺序，无任何预设 ----
; 变量：K（key定义顺序，A先B后/B先A后），
;       M（mode/HotIf是否不同），
;       S（S0:无左右指定，S1:有左右指定）

; ========== 1. 单mode、无左右 ===========
; ---- Group 1: 单mode-S0 ----
/** @type {VimDWindow} */
win := VimD.initWin("General", "A")
win.keyToMode1 := "F1"
win.keyToMode0 := "F2"
/** @type {VimDMode} */
mode1 := win.initMode(1, , "normal", 3)
BindLogger(lhs, msg) {
    mode1.MapKey(lhs, ObjBindMethod(logger, "info", msg), "msgbox")
}

; Case1: A先B后
BindLogger("!a", "A_S0")
BindLogger("!a", "B_S0")
; type !a
; actual =
; result =
; Case2: B先A后
BindLogger("^a", "B_S0")
BindLogger("^a", "A_S0")
; type ^a
; actual =
; result =

; ---- Group 2: 单mode-S1 ----
; Case1: A先B后
BindLogger("!b", "A_S1")
BindLogger(">!b", "B_S0")
; type !b
; actual =
; result =
; Case2: B先A后
BindLogger("<^b", "B_S0")
BindLogger("^b", "A_S1")
; type ^b
; actual =
; result =

; ========== 2. 双mode ===========
/** @type {VimDWindow} */
win2 := VimD.initWin("General2", "A")
win2.keyToMode1 := "F1"
win2.keyToMode0 := "F2"
/** @type {VimDMode} */
mode2 := win2.initMode(1, , "normal", 3)
BindLogger2(lhs, msg) {
    mode2.MapKey(lhs, ObjBindMethod(logger, "info", msg), "msgbox")
}

; ---- Group 3: 双mode-S0 ----
; Case1: A先B后
BindLogger2("!c", "A_S0")
BindLogger("!c", "B_S0")
; 激活win/win2测试 !c
; actual =
; result =
; Case2: B先A后
BindLogger("^c", "B_S0")
BindLogger2("^c", "A_S0")
; 激活win/win2测试 ^c
; actual =
; result =

; ---- Group 4: 双mode-左右交叉1 ----
; Case1: A先B后
BindLogger2(">!d", "A_S1")
BindLogger("!d", "B_S0")
; 激活win/win2测试 !d
; actual =
; result =
; Case2: B先A后
BindLogger("^d", "B_S0")
BindLogger2("<^d", "A_S1")
; 激活win/win2测试 ^d
; actual =
; result =

; ---- Group 5: 双mode-左右交叉2 ----
; Case1: A先B后
BindLogger(">!e", "A_S1")
BindLogger2("!e", "B_S0")
; 激活win/win2测试 !e/ >!e
; actual =
; result =
; Case2: B先A后
BindLogger2("^e", "B_S0")
BindLogger("<^e", "A_S1")
; 激活win/win2测试 ^e/ <^e
; actual =
; result =

; ========== 3. 总结空间 =============
; Group 1（单mode-S0）:
;   Case1: A先B后 actual=      result=
;   Case2: B先A后 actual=      result=
; Group 2（单mode-S1）:
;   Case1: A先B后 actual=      result=
;   Case2: B先A后 actual=      result=
; Group 3（双mode-S0）:
;   Case1: A先B后 actual=      result=
;   Case2: B先A后 actual=      result=
; Group 4（双mode-左右交叉1）:
;   Case1: A先B后 actual=      result=
;   Case2: B先A后 actual=      result=
; Group 5（双mode-左右交叉2）:
;   Case1: A先B后 actual=      result=
;   Case2: B先A后 actual=      result=
; --------
; 归纳：
;   - K变量影响概述：
;   - M变量影响概述：
;   - S变量影响概述：
;   - 多变量交互条目总结：
;   - 经验法则/优先级推测：
