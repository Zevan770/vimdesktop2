/**
 * @description 按键序列 
 * 按键的几种形态: 
 */
class VimDKeySeqence {

    static SplitChar := " "
    /**
     * @description 按键序列 
     * @type {Array<String>} 
     */
    keys := []

    __New(keys := []) {
        this.keys := keys
    }

    /**
     * @description 将给定的 lhs 转换为按键序列
     * @param {String} lhs
     */
    static Lhs2KeySeq(lhs) {
        strs := StrSplit(lhs, this.SplitChar)
        arr := []
        for _, str in strs {
            arr.Push(KeyUtil.Lhs2Hot(str))
        }
        return VimDKeySeqence(arr)
    }

    ToString() {
        return this.keys.join(VimDKeySeqence.SplitChar)
    }

    /**
     * @description 添加按键到序列
     * @param {String} key
     */
    AddKey(key) {
        this.keys.push(key)
    }

    /**
     * @return 一个移除序列中的最后一个按键的新序列
     */
    GetLeaderKeys() {
        if (this.keys.length == 0) {
            return VimDKeySeqence()
        }
        leaderKeys := this.keys.clone()
        leaderKeys.Pop()
        return VimDKeySeqence(leaderKeys)
    }

    GetLastKey() {
        return this.keys[-1]
    }
}
