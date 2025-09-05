#Requires AutoHotkey v2.0
class VimDActionManager {
    /** @type {VimDMode} */
    mode := ""

    /** @type {Map<String, VimDAction>} */
    actions := Map()

    __new(mode) {
        this.mode := mode
        this.actions.CaseSense := true
    }

    HasAction(keySeq) {
        return this.actions.Has(keySeq)
    }

    GetAction(keySeq) {
        return this.actions[keySeq]
    }

    MapKey(lhs, rhs := unset, desc := unset, condition := unset) {
        this._Map(lhs, rhs?, desc?, "", "normal")
    }

    _Map(lhs, rhs := "", desc := "", condition := "", type := "normal") {
        /** @type  {VimDKeySeqence} */
        keySeq := VimDKeySeqence.Lhs2KeySeq(lhs)
        /** @type {VimDAction} */
        action := VimDAction()
        action.keySeq := keySeq
        action.rhs := rhs
        action.type := rhs ? "normal" : "leader"
        action.desc := IsSet(desc) ? desc : rhs
        action.type := type
        action.mode := this.mode
        ; key 级别 condition 已移除，条件由模式或窗口级别处理

        leaderKeys := keySeq.GetLeaderKeys()
        ; 自动为 leaderKeys 定义一个空的 action
        if (!this.actions.has(leaderKeys.ToString()) && leaderKeys.keys.length) {
            this._Map(leaderKeys.ToString(), "", leaderKeys.ToString(), , "leader")
        }

        ; logger.debug(Objs2Str(action))

        for key in action.keySeq.keys {
            if (!this.mode.win.registeredHotkeys.has(key)) { ;单键避免重复定义
                ; 不再为单键绑定 per-key condition，使用模式/窗口的 HotIf 判断
                HotIf(this.mode.hotIfCondition)
                Hotkey(key, ObjBindMethod(this.mode.win, "keyIn"))
                this.mode.win.registeredHotkeys.Push(key)
            }
        }

        this.actions[keySeq.ToString()] := action
    }
}
