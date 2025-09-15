#Include <lxiko\ConfOverride>

RestartKanata() {
    ProcessClose("kanata-gui.exe")
    Run("kanata-gui.exe --port 4039 --nodelay", , "Hide")
}

RestartKanata()

; ---- VimD优先级穷举测试样例 ----
; 变量：K（key定义顺序），M（mode/HotIf先后），S（左右修饰符与否）
; 共三维，每维两种（0/1）；三元组记法：(K,M,S)

; ========== 1. 单变量变化，其他保持相同 ==========
/** @type {VimDWindow} */
win := VimD.initWin("General", "A")
win.keyToMode1 := "F1"
win.keyToMode0 := "F2"
/** @type {VimDMode} */
mode1 := win.initMode(1, , "normal", 3)

; 公共函数
BindLogger(lhs, msg) {
    mode1.MapKey(lhs, ObjBindMethod(logger, "info", msg), "msgbox")
}

; ---- 1.1 变K ----
; MapA: 先定义      MapB: 后定义
BindLogger("!a", "A_K0")    ; MapA (K=0,M=0,S=0)
mode1.MapKey("!a", ObjBindMethod(logger, "info", "A_K1"), "msgbox") ; MapB (K=1,M=0,S=0)
; type !a
; actual = A_K1
; result = 后定义优先

; ---- 1.2 变M ----
/** @type {VimDWindow} */
win2 := VimD.initWin("General2", "A")
win2.keyToMode1 := "F1"
win2.keyToMode0 := "F2"
/** @type {VimDMode} */
mode2 := win2.initMode(1, , "normal", 3)
BindLogger2(lhs, msg) {
    mode2.MapKey(lhs, ObjBindMethod(logger, "info", msg), "msgbox")
}
BindLogger2("!b", "B_M1")    ; MapA (K=0,M=1,S=0)
BindLogger("!b", "B_M0")     ; MapB (K=0,M=0,S=0)
; 激活win/win2测试 !b
; actual = B_M1
; result = mode/HotIf后定义优先

; ---- 1.3 变S ----
BindLogger("!c", "C_S0")     ; MapA (K=0,M=0,S=0)
BindLogger(">!c", "C_S1")    ; MapB (K=0,M=0,S=1)
; type >!c
; actual = C_S1
; result = 指定左右优先

; ========== 2. 双变量同时变化，单变量保持 ==========
; --- 2.1 变K+M，S同 ----
BindLogger("!d", "D_K0M0")
win2.keyToMode1 := "F1"
mode2.MapKey("!d", ObjBindMethod(logger, "info", "D_K1M1"), "msgbox")
; 分别在win/win2激活后 type !d
; actual = D_K0M0
; result = 只受K影响（win正常取K顺序）

; --- 2.2 变K+S，M同 ----
BindLogger("!e", "E_K0S0")
mode1.MapKey(">!e", ObjBindMethod(logger, "info", "E_K1S1"), "msgbox")
; type >!e
; actual = E_K1S1
; result = 指定左右最强，覆盖K

; --- 2.3 变M+S，K同 ----
BindLogger(">!f", "F_M0S1")
BindLogger2("!f", "F_M1S0")
; 分别在win/win2激活后 type !f/ >!f
; actual = F_M0S1
; result = 指定左右最强，覆盖M

; ========== 总结结论空格 ==========
; 单变量系列:
;   - K = 后定义优先
;   - M = Mode/HotIf后定义优先
;   - S = 指定左右优先
; 双变量系列:
;   - K+M = 仍以K为主（单窗口时）, 多窗口时优先激活窗口的定义
;   - K+S = S决定
;   - M+S = S决定
; 结论:
;   S（左右专指）> K（后定义）≈M（mode后定义），S 一旦成立直接覆盖其他
