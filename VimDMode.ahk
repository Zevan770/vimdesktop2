#Requires AutoHotkey v2.0
class VimDMode {
    /** @type {VimDWindow} */
    win := unset

    /** @type {VimDActionManager} */
    actionManager := ""

    /** @type {VimDAction} */
    tmpAction := ""

    /** @type {Map<String, String>} */
    objTips := Map()

    /** @type {VimDKeySeqence} */
    keySeq := VimDKeySeqence()

    /** @type {Func} */
    onBeforeKey := ""

    /** @type {String} */
    onAfterKey := ""

    /** @type {String} */
    onBeforeDo := ""

    /** @type {String} */
    onAfterDo := ""

    /** @type {BoundFunc} */
    hotIfCondition := unset

    __new(idx, win, name := "") {
        this.index := idx
        this.win := win ;标记是哪个窗口的mode
        this.actionManager := VimDActionManager(this) ; 初始化 actionManager
        name = name != "" ? name : format("mode{1}", idx)
        this.name := this.win.name . "-" . name
        this.objTips.CaseSense := true
        this.hotIfCondition := (p*) => this.win.Active() && this.Active() && this.checkKey(p*)
    }

    ;脚本运行过程出错，要先运行此命令退出，否则下次按键会因为 keySeq 误判(往往使下一按键无效)
    ;NOTE 执行命令或中途退出才执行
    ;type -1=执行前半段 0=全部执行 1=执行后半段
    init(type := 0) {
        ;logger.debug("init tp=", tp, "start")
        if (type <= 0) { ;用于在do之前先初始化一部分
            this.keySeq.keys := []
            ; 清除提示
            this._ShowTip("")
            VimD.HideTips1()
            VimD.HideTips()
        }
        if (type >= 0) { ;影响执行逻辑的属性
            this.win.count := 0
            this.win.isRepeating := false
            this.win.skipRepeat := false
        }
    }

    ;NOTE 被keyIn调用
    _keyIn(thisHotkey, byScript) {
        logger.debug("keyIn", thisHotkey, " in mode ", this.name)

        ;第一个按键
        if (this.handleSpecialKey(thisHotkey)) {
            exit
        }

        ; 当按下 leader（即当前 keySeq 对应的 action 存在但为 leader 类型）时，显示后续可选按键
        this.tmpAction := this.actionManager.GetAction(this.keySeq)
        if (this.tmpAction && this.tmpAction.type == "leader") {
            ; 获取所有以当前 keySeq 为前缀的 actions
            arrMatch := this.actionManager.GetActionsStartingWith(this.keySeq)
            this.ShowTips(arrMatch)
            return
        }

        if (this.tmpAction.rhs != "") {
            this.Exec(this.tmpAction.rhs, this.win.GetCount(), this.tmpAction.desc)
            this.init()
        } else {
            ; 如果没有匹配的具体动作，尝试显示可能的后续映射
            if (this.actionManager.HasAction(this.keySeq)) {
                arrMatch := this.actionManager.GetActionsStartingWith(this.keySeq)
                this.ShowTips(arrMatch)
            }
        }

    }

    HandleSpecialKey(thisHotkey) {
        if (!this.actionManager.HasAction(thisHotkey)) {
            return false
        }
        if (thisHotkey ~= "^\d$") {
            this.HandleCount(integer(thisHotkey)) ;因为要传入参数，所以单独处理
            return true
        } else if (thisHotkey == "{BackSpace}") {
            this.GlobalActionBS() ;因为无需 init，所以单独处理
            return true
        } else if (thisHotkey == ".") {
            this.init(-1)
            this.GlobalActionRepeat() ;一般是 Exec(action.rhs, this.win.GetCount())，repeat 刚好相反
            this.init(1)
            return true
        } else {
            return false
        }
    }

    HandleCount(keyMap) {
        if (keyMap == "{BackSpace}") {
            if (this.win.count > 9) { ;两位数
                this.win.count := this.win.count // 10
                logger.debug("this.win.count=", this.win.count)
            } else {
                this.init()
                return
            }
        } else {
            this.win.count := this.win.count ? this.win.count * 10 + integer(keyMap) : integer(keyMap)
        }
        this._ShowTip(string(this.win.count))
    }

    ;-----------------------------------maps-----------------------------------

    EscapeCondition(thisHotkey) {
        res := this.win.count == 0 && this.keySeq.keys.length == 0
        logger.debug("EscapeCondition=" res)
        return res
    }

    MapDefault(opt) {
        if (this.index == 1) {
            if (this.win.keyToInsert != "") {
                ; 不再接受 key 级别 condition，使用模式的 Active/BeforeKey 等进行判断
                this.MapKey(this.win.keyToInsert, ObjBindMethod(this, "GlobalActionEscape"), "进入 insert")
            }
        } else if (this.index == 2) {
            ; this.MapKey("escape", ObjBindMethod(this, "GlobalActionEscape"), "escape")
            ; this.MapKey("BackSpace", ObjBindMethod(this, "GlobalActionBS"), "BackSpace")

            if (this.win.keyToNormal != "")
                this.MapKey(this.win.keyToNormal, ObjBindMethod(this.win, "SwitchMode", 1), "进入 normal")

            n := 0 ;二进制的位数<super>(从右开始)
            if ((opt & 2 ** n) >> n) ;也可以用 "10" 这种字符串来判断
                this.MapCount()
            n++
            if ((opt & 2 ** n) >> n)
                logger.info(this.name, " Mapping BS key")
            this.MapKey(".", "", "重做")
        }
    }

    MapCount() {
        logger.debug(this.name, " Mapping count keys 0-9")
        loop (10)
            this.MapKey(string(A_Index - 1), "", format("<{1}>", A_Index - 1))
    }

    /**
     * @description 映射按键
     * @param {String} lhs
     * @param {String|Func} rhs
     * @param {String} desc
     * @param {Func} condition
     */
    MapKey(lhs, rhs := unset, desc := unset) {
        this._Map(lhs, rhs, desc)
    }

    ;-----------------------------------do__-----------------------------------
    BeforeKey(p*) => !CaretGetPos() ;有些软件要用 UIA.GetFocusedElement().CurrentControlType != UIA.ControlType.Edit
    BeforeKeyUIA(p*) => UIA.GetFocusedElement().CurrentControlType != UIA.ControlType

    ;最终执行的命令
    ;因为 GlobalActionRepeat 调用，所以把 cnt 放参数
    Exec(rhs, count, comment := "") {
        ;处理 repeat 和 count
        if (!this.win.isRepeating) {
            this.win.lastAction := this.tmpAction
            this.win.lastCount := count
            ; TODO history
        }
        ;NOTE 运行
        loop (count) {
            this.ExecFunc(rhs, true)
        }
        if (isobject(this.onAfterDo))
            this.ExecFunc(this.onAfterDo)
    }

    ExecFunc(rhs, errExit := false) {
        if !(rhs is string) {
            rhs()
            return true
        }
        if (type(%rhs%).isFunc()) {
            %rhs%()
            return true
        }
        if !(rhs ~= "i)^[a-z]:[\\/]") {
            if (rhs ~= "^\w+\(\S*\)$") { ;运行function()
                arr := StrSplit(substr(rhs, 1, strlen(rhs) - 1), "(")
                (arr[2] == "") ? %arr[1]%() : %arr[1]%(arr[2])
                return true
            } else if (rhs ~= "^(\w+)\.(\w+)\((.*)\)$") { ;NOTE 运行 class.method(param1)
                RegExMatch(rhs, "^(\w+)\.(\w+)\((.*)\)$", &m)
                (m[3] != "") ? %m[1]%.%m[2]%(m[3]) : %m[1]%.%m[2]%()
                return true
            }
            if (rhs ~= '^\{\w{8}(-\w{4}){3}-\w{12}\}$') { ;clsid
                rhs := "explorer.exe shell:::" . rhs
            } else if (rhs ~= '^\w+\.cpl(,@?\d?)*$') { ;cpl
                rhs := "control.exe " . rhs
                ;} else if (substr(funcObj,1,12) == "ms-settings:") {
                ;    funcObj := funcObj
                ;} else if (funcObj ~= 'i)^control(\.exe)?\s+\w+\.cpl$') {
                ;    funcObj := funcObj
            }
            tooltip(rhs)
            run(rhs)
            SetTimer(tooltip, -1000)
            return true
        }
        if (errExit)
            exit
        else
            return false
    }

    GlobalActionEscape() {
        if (this.index == 0) {
            this.win.SwitchMode(2)
        } else {
            this.win.skipRepeat := true
        }
    }

    ;删除最后一个字符
    GlobalActionBS() {
        ; this.win.skipRepeat := true
        ; if (this.keySeq.length) {
        ;     this.HandleMultiKey()
        ; } else if (this.win.count) {
        ;     this.HandleCount("{BackSpace}")
        ; }
        ;TODO
    }
    GlobalActionRepeat() {
        this.win.isRepeating := true
        if (!IsObject(this.win.lastAction) || this.win.lastAction == "")
            return
        this.Exec(this.win.lastAction.rhs, this.win.lastCount)
        this.win.isRepeating := false
    }
    ;-----------------------------------tip-----------------------------------

    ShowTips(arrMatch) {
        if (!IsObject(arrMatch) || !arrMatch.length) {
            this._ShowTip("")
            return
        }
        ; 构建提示文本：显示 keySeq -> desc
        s := ""
        for action in arrMatch {
            ; 显示下一键（去掉公共前缀）和描述
            keyStr := action.keySeq.ToString()
            ; 将空格显示为特殊符号
            displayKey := RegExReplace(keyStr, "\\s|\\{space\\}", "☐")
            ; 如果有 leader 前缀，去掉已按下的前缀部分以提示下一步
            if (this.keySeq && this.keySeq.ToString() != "") {
                pref := this.keySeq.ToString()
                if (SubStr(displayKey, 1, StrLen(pref)) == pref)
                    displayKey := SubStr(displayKey, StrLen(pref) + 1)
            }
            s .= format("{1}`t{2}`n", displayKey, action.desc ? action.desc : "")
        }
        this._ShowTip(s)
    }

    ;NOTE
    _ShowTip(str) {
        ; 如果传入空字符串，则清除 tooltip
        if (!str) {
            tooltip
            return
        }
        ; 根据是否提供自定义位置显示 tooltip
        if (isobject(this.win.skipRepeat)) {
            cmToolTip := A_CoordModeToolTip
            CoordMode("ToolTip", "window") ;强制为 window 模式
            arrXY := this.win.skipRepeat.call()
            tooltip(str, arrXY[1], arrXY[2], VimD.tipLevel)
            CoordMode("ToolTip", cmToolTip)
        } else {
            MouseGetPos(&x, &y)
            x += 20 * A_ScreenDPI // 96 ;NOTE 防止鼠标挡住
            y += 20 * A_ScreenDPI // 96
            tooltip(str, x, y, VimD.tipLevel)
        }
    }

    Active() {
        logger.trace("curMode:checking =", this.win.curMode.name, ":", this.name)
        if (this.win.curMode.name != this.name) {
            return false
        }
        if (this.onBeforeKey IS Func) {
            if (!this.onBeforeKey.call()) {
                logger.debug("onBeforeKey condition failed")
                return false
            }
        }
        return true
    }

    checkKey(thisHotkey) {
        this.keySeq.AddKey(thisHotkey)

        if (!this.actionManager.HasAction(this.keySeq)) {
            this.init()
            return false
        }
        return true
    }

    _Map(lhs, rhs := "", desc := "") {
        logger.info("Mapping key ", lhs, " to ", rhs, " in mode ", this.name)
        /** @type  {VimDKeySeqence} */
        keySeq := lhs IS String ? VimDKeySeqence.Lhs2KeySeq(lhs) : lhs
        /** @type {VimDAction} */
        action := VimDAction()
        action.keySeq := keySeq
        action.rhs := rhs
        action.type := rhs ? "normal" : "leader"
        action.desc := IsSet(desc) ? desc : rhs
        action.type := type
        action.mode := this

        leaderKeys := keySeq.GetLeaderKeys()
        ; 自动为 leaderKeys 定义一个空的 action
        if (!this.actionManager.HasAction(leaderKeys) && leaderKeys.keys.length) {
            this._Map(leaderKeys, "",)
        }

        ; logger.debug(Objs2Str(action))

        for key in action.keySeq.keys {
            if (!this.actionManager.mode.win.registeredHotkeys.has(key)) { ;单键避免重复定义
                ; 不再为单键绑定 per-key condition，使用模式/窗口的 HotIf 判断
                HotIf(this.actionManager.mode.hotIfCondition)
                Hotkey(key, ObjBindMethod(this.actionManager.mode.win, "keyIn"))
                this.actionManager.mode.win.registeredHotkeys.Push(key)
            }
        }

        this.actionManager.actions[keySeq.ToString()] := action
    }
}