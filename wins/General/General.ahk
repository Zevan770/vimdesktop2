RestartKanata() {
    ProcessClose("kanata-gui.exe")
    Run("kanata-gui.exe --port 4039 --nodelay", , "Hide")
}

RestartKanata()


win := VimD.initWin("General", "")
win.keyToInsert := "F1"
win.keyToNormal := "F2"
/** @type {VimDMode} */

VimDMode.Prototype.MapKomorebic := (this, key, args) => (
    this.MapKey(key, () => (
        Run("Komorebic.exe " args, , "Hide")
    ), "Komo" args)
)

; {{{ komorebi

mode := win.initMode(1, , "normal", 0)
modeK := win.initMode(3, , "komorebi", 3)
win.SwitchMode(2)
; 基础窗口移动
mode.MapKomorebic("<!h", "focus left")
mode.MapKomorebic("<!j", "focus down")
mode.MapKomorebic("<!k", "focus up")
mode.MapKomorebic("<!l", "focus right")

; resize
mode.MapKomorebic("<!+h", "resize-axis horizontal decrease")
mode.MapKomorebic("<!+j", "resize-axis vertical decrease")
mode.MapKomorebic("<!+k", "resize-axis vertical increase")
mode.MapKomorebic("<!+l", "resize-axis horizontal increase")
mode.MapKey("<!e", Reload, "reload")
; 工作区切换
loop 9
    mode.MapKomorebic("Numpad" A_Index, "focus-workspace " A_Index - 1)

; 最大化/浮动/忽略
mode.MapKomorebic("<!z", "toggle-maximize")
mode.MapKomorebic("<!a", "toggle-float")

KomoAndTip(*) {
    win.SwitchMode(3)
    modeK.ShowTips(modeK.actionManager.GetActionsStartingWith(modeK.keySeq))
}

mode.MapKey("<!w", KomoAndTip, "komoMode")

; komorebi模式下常用按键
modeK.MapKey("esc", ObjBindMethod(win, "SwitchMode", 1), "normalMode")
modeK.MapKey("space", ObjBindMethod(win, "SwitchMode", 1), "normalMode")
; send/move to workspace
modeK.MapKomorebic("^0", "move-to-workspace 9")
modeK.MapKomorebic("^1", "move-to-workspace 0")
modeK.MapKomorebic("^2", "move-to-workspace 1")
modeK.MapKomorebic("^3", "move-to-workspace 2")
modeK.MapKomorebic("^4", "move-to-workspace 3")
modeK.MapKomorebic("^5", "move-to-workspace 4")
modeK.MapKomorebic("^6", "move-to-workspace 5")
modeK.MapKomorebic("^7", "move-to-workspace 6")
modeK.MapKomorebic("^8", "move-to-workspace 7")
modeK.MapKomorebic("^9", "move-to-workspace 8")
modeK.MapKomorebic("<!0", "send-to-workspace 9")
modeK.MapKomorebic("<!1", "send-to-workspace 0")
modeK.MapKomorebic("<!2", "send-to-workspace 1")
modeK.MapKomorebic("<!3", "send-to-workspace 2")
modeK.MapKomorebic("<!4", "send-to-workspace 3")
modeK.MapKomorebic("<!5", "send-to-workspace 4")
modeK.MapKomorebic("<!6", "send-to-workspace 5")
modeK.MapKomorebic("<!7", "send-to-workspace 6")
modeK.MapKomorebic("<!8", "send-to-workspace 7")
modeK.MapKomorebic("<!9", "send-to-workspace 8")
; 其它常用
modeK.MapKomorebic("[", "cycle-stack previous")
modeK.MapKomorebic("]", "cycle-stack next")
modeK.MapKomorebic("s h", "stack left")
modeK.MapKomorebic("s j", "stack down")
modeK.MapKomorebic("s k", "stack up")
modeK.MapKomorebic("s l", "stack right")
modeK.MapKomorebic("s u", "unstack")
modeK.MapKomorebic("e s", "stack-all")
modeK.MapKomorebic("e u", "unstack-all")
modeK.MapKomorebic("e p", "toggle-pause")
modeK.MapKomorebic("e g", "gui")
modeK.MapKomorebic("e x", "stop")
modeK.MapKomorebic("f", "toggle-monocle")
modeK.MapKomorebic("h", "focus left")
modeK.MapKomorebic("j", "focus down")
modeK.MapKomorebic("k", "focus up")
modeK.MapKomorebic("l", "focus right")
modeK.MapKomorebic("m", "minimize")
modeK.MapKomorebic("n", "cycle-focus next")
modeK.MapKomorebic("p", "cycle-focus previous")
modeK.MapKomorebic(",", "cycle-workspace previous")
modeK.MapKomorebic(".", "cycle-workspace next")
modeK.MapKomorebic("^,", "cycle-move-to-workspace previous")
modeK.MapKomorebic("^.", "cycle-move-to-workspace next")
modeK.MapKomorebic("o", "cycle-layout next")
modeK.MapKomorebic("q", "close")
modeK.MapKomorebic("t", "focus-last-workspace")
modeK.MapKomorebic("v", "quick-load-resize true")
modeK.MapKomorebic("w", "cycle-monitor next")
modeK.MapKomorebic("x", "stop")
modeK.MapKomorebic("y", "cycle-move-to-monitor previous")
; }}}


/* <!h=run|komorebic focus left
<!j=run|komorebic focus down
<!k=run|komorebic focus up
<!l=run|komorebic focus right

<Numpad1>=run|komorebic focus-workspace 0
<Numpad2>=run|komorebic focus-workspace 1
<Numpad3>=run|komorebic focus-workspace 2
<Numpad4>=run|komorebic focus-workspace 3
<Numpad5>=run|komorebic focus-workspace 4
<Numpad6>=run|komorebic focus-workspace 5
<Numpad7>=run|komorebic focus-workspace 6
<Numpad8>=run|komorebic focus-workspace 7
<Numpad9>=run|komorebic focus-workspace 8
<Numpad0>=run|komorebic focus-workspace 9

; <!f=run|win-vind -c <easyclick><click_left>
; <!s=run|win-vind -c <easyclick_all><click_left>
; <!i=run|win-vind -c <focus_textarea>
    ; <w-c>=run|explorer
    ; <w-k>=<VimDConfig_Keymap>
    ; ^1=<ToggleTitleBar>
    ; <space>=<space>
    ; <sp-j>=<down>

<!w=<komoMode>

[global.komo]
0=run|komorebic focus-workspace 9
1=run|komorebic focus-workspace 0
2=run|komorebic focus-workspace 1
3=run|komorebic focus-workspace 2
4=run|komorebic focus-workspace 3
5=run|komorebic focus-workspace 4
6=run|komorebic focus-workspace 5
7=run|komorebic focus-workspace 6
8=run|komorebic focus-workspace 7
9=run|komorebic focus-workspace 8
    ; <!h=run|komorebic stack left
    ; <!j=run|komorebic stack down
    ; <!k=run|komorebic stack up
    ; <!l=run|komorebic stack right
    ; [=run|komorebic cycle-workspace previous
    ; ]=run|komorebic cycle-workspace next
    ; h=run|komorebic resize right decrease
    ; j=run|komorebic resize down decrease
    ; k=run|komorebic resize down increase
    ; l=run|komorebic resize right increase
    ; 启用（1）/禁用（0） 插件，默认禁用
+f=run|komorebic toggle-maximize
+h=run|komorebic resize-axis horizontal decrease
+j=run|komorebic resize-axis vertical decrease
+k=run|komorebic resize-axis vertical increase
+l=run|komorebic resize-axis horizontal increase
^0=run|komorebic move-to-workspace 9
^1=run|komorebic move-to-workspace 0
^2=run|komorebic move-to-workspace 1
^3=run|komorebic move-to-workspace 2
^4=run|komorebic move-to-workspace 3
^5=run|komorebic move-to-workspace 4
^6=run|komorebic move-to-workspace 5
^7=run|komorebic move-to-workspace 6
^8=run|komorebic move-to-workspace 7
^9=run|komorebic move-to-workspace 8

<!0=run|komorebic send-to-workspace 9
<!1=run|komorebic send-to-workspace 0
<!2=run|komorebic send-to-workspace 1
<!3=run|komorebic send-to-workspace 2
<!4=run|komorebic send-to-workspace 3
<!5=run|komorebic send-to-workspace 4
<!6=run|komorebic send-to-workspace 5
<!7=run|komorebic send-to-workspace 6
<!8=run|komorebic send-to-workspace 7
<!9=run|komorebic send-to-workspace 8
i=run|komorebic ignore


<esc>=<normalMode>
<space>=<normalMode>
a=run|komorebic toggle-float
c=run|komorebic quick-save-resize true
d=<>
[=run|komorebic cycle-stack previous
]=run|komorebic cycle-stack next
sh=run|komorebic stack left
sj=run|komorebic stack down
sk=run|komorebic stack up
sl=run|komorebic stack right
su=run|komorebic unstack

es=run|komorebic stack-all
eu=run|komorebic unstack-all
ep=run|komorebic toggle-pause
eg=run|komorebic gui
ex=run|komorebic stop

f=run|komorebic toggle-monocle
g=<AlwaysOnTop>
h=run|komorebic focus left
j=run|komorebic focus down
k=run|komorebic focus up
l=run|komorebic focus right
m=run|komorebic minimize
n=run|komorebic cycle-focus next
p=run|komorebic cycle-focus previous

,=run|komorebic cycle-workspace previous
.=run|komorebic cycle-workspace next
^,=run|komorebic cycle-move-to-workspace previous
^.=run|komorebic cycle-move-to-workspace next
o=run|komorebic cycle-layout next
q=run|komorebic close
t=run|komorebic focus-last-workspace
v=run|komorebic quick-load-resize true
w=run|komorebic cycle-monitor next
x=run|komorebic stop
y=run|komorebic cycle-move-to-monitor previous
z=<>

; ^h=run|komorebic move left
; ^j=run|komorebic move down
; ^k=run|komorebic move up
; ^l=run|komorebic move right */
