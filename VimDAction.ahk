#Requires AutoHotkey v2.0
class VimDAction {
    /**
     * @description 模式 
     * @type {VimDMode} 
     */
    mode := ""

    /**
     * @typedef {("normal"|"leader")} VimDActionType 映射类型
     */

    /**
     * @type {VimDActionType}
     */
    type := "normal"

    /**
     * @description 
     * @type {VimDKeySeqence} 
     */
    keySeq := []

    /**
     * @description 动作 
     * @type {String|Func} 
     */
    rhs := ""

    /**
     * @description 描述 
     * @type {String} 
     */
    desc := ""

    /**
     * @description 以此键开头的映射
     * @type {Map<String, VimDAction>}
     */
    mapping := Map()

    /**
     * @description 条件
     * @type {Func}
     */
    condition := ""

    /**
     * @description 简短描述
     * @type {String}
     */

    shortDesc := ""

}
