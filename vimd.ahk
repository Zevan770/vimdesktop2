#Requires AutoHotkey v2.0
DllCall("AttachConsole", "UInt", -1)
#SingleInstance force
A_MaxHotkeysPerInterval := 1000

class VimD {
    static arrModeName := ["None", "Vim"
    ]
    ;static charSplit := "※" ;分隔各命令
    /** @type {VimDWindow} */
    static curWin := {} ;记录当前的窗口，用来出错后 init
    static tipLevel := 15
    static tipLevel1 := 16 ;其他辅助显示

    /** @type {Map<String, VimDWindow>} */
    static wins := Map() ;在 initWin里设置

    static __New() {
        SetTitleMatchMode('Fast')
        ; this.logger.is_use_editor := true
        ; this.logger.level := this.LogLevel.trace
        logger.is_use_editor := true
        logger.is_out_console := true
        logger.is_out_file := false
        logger.is_formate := false
        logger.is_simple_path := true
        logger.set_pattern("[%Y-%m-%d %H:%M:%S.%F] [%^%=8l%$] [%5!ius] %v")
        logger.level := LogLevel.DEBUG
        ;HotIfWinActive ;TODO 关闭
    }

    ;NOTE 核心，由各插件自行调用
    /**
     * 
     * @param winName 
     * @param winTitle 
     * @param noWinTitle
     * @returns {VimDWindow}
     */
    static InitWin(winName, winTitle, noWinTitle := "") {
        ;msgbox(winName . "`n" . json.stringify(this.wins, 4))
        if !this.wins.has(winName)
            this.wins[winName] := VimDWindow(winName)
        /** @type {VimDWindow} */
        win := this.wins[winName]
        win.winTitle := winTitle
        win.noWinTitle := noWinTitle
        return win
    }

    ;NOTE 运行出错后必须要执行此方法，否则下次 VimD 的第一个键会无效
    static ErrorHandler(msg := "") {
        if (IsObject(this.curWin))
            this.curWin.curMode.init()
        if (msg != "") {
            msgbox(A_ThisFunc . "`n" . msg, , 0x40000)
            exit
        }
    }

    ;Mode.ShowTips
    static HideTips() {
        tooltip(, , , VimD.tipLevel)
    }

    static HideTips1() => tooltip(, , , VimD.tipLevel1)
    static ShowTips1(str, x := 0, y := 0) => tooltip(str, x, y, VimD.tipLevel1) ;辅助显示，固定在某区域

    ; static checkInclude() {
    ;     SplitPath(A_LineFile, , &dir)
    ;     fp := format("{1}\VimDInclude.ahk", dir)
    ;     str := fileread(fp)
    ;     arr := StrSplit(rtrim(fileread(fp), "`r`n"), "`n", "`r").map(v => StrSplit(v, "\")[2])
    ;     ;objInclude := StrSplit(rtrim(fileread(fp),"`r`n"), "`n", "`r").map(v=>)
    ;     if (hyf_checkNewPlugin(A_WorkingDir "\VimDInclude.ahk", [[A_WorkingDir, "wins"
    ;     ]], "VimD_")) {
    ;         f := FileOpen(fp, "w", "utf-8-raw")
    ;         strInclude := ""
    ;         loop files, format("{1}\wins\*", A_LineFile.dir()), "D"
    ;             strInclude .= format("#include wins\{1}\VimD_{1}.ahk`n", A_LoopFileName)
    ;         f.write(strInclude)
    ;         f.close()
    ;     }
    ; }

}

; OnError(ErrorHandler)
; ErrorHandler(exception, mode) {
;     msgbox(exception.file . "`n" . exception.line, , 0x40000)
;     VimD.ErrorHandler() ;NOTE 否则 VimD 下个按键会无效
; }

#include VimDInclude.ahk
#include VimDWindow.ahk
#Include VimDActionManager.ahk
#Include VimDAction.ahk
#Include VimDKeySequence.ahk
#include VimDMode.ahk