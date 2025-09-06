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
        if !(keySeq IS String)
            keySeq := keySeq.ToString()
        return this.actions.Has(keySeq)

    }

    GetAction(keySeq) {
        if !(keySeq IS String)
            keySeq := keySeq.ToString()
        return this.actions[keySeq]
    }

    /**
     * 返回以指定 keySeq 前缀开始的 action 列表
     * @param {VimDKeySeqence|String} prefix
     * @returns {Array} 返回 action 对象数组
     */
    GetActionsStartingWith(prefix) {
        if !(prefix IS String)
            prefix := prefix.ToString()
        arr := []
        for k, v in this.actions {
            if (SubStr(k, 1, StrLen(prefix)) == prefix)
                arr.Push(v)
        }
        return arr
    }
}
