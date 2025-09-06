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
    ; 已移除 key 级别的 condition 功能，条件现在由模式/窗口级别处理

    /**
     * @description 简短描述
     * @type {String}
     */

    shortDesc := ""

}
