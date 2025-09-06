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

}
