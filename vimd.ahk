#Requires AutoHotkey v2.0
; DllCall("AttachConsole", "UInt", -1)
#SingleInstance Force
#UseHook true

; #WinActivateForce   ; 先关了遇到相关问题再打开试试
InstallKeybdHook    ; 这个可以重装 keyboard hook, 提高自己的 hook 优先级, 以后可能会用到
ListLines False     ; 也许能提升一点点性能 ( 别抱期待 ), 当有这个需求时再打开试试
; #Warn All, Off      ; 也许能提升一点点性能 ( 别抱期待 ), 当有这个需求时再打开试试

DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr") ; 多显示器不同缩放比例会导致问题: https://www.autohotkey.com/boards/viewtopic.php?f=14&t=13810
SetMouseDelay 0                                           ; SendInput 可能会降级为 SendEvent, 此时会有 10ms 的默认 delay
SetWinDelay 0                                             ; 默认会在 activate, maximize, move 等窗口操作后睡眠 100ms
A_MaxHotkeysPerInterval := 256                            ; 默认 70 可能有点低, 即使没有热键死循环也触发警告
SendMode "Event"                                          ; 执行 SendInput 的期间会短暂卸载 Hook, 这时候松开引导键会丢失 up 事件, 所以 Event 模式更适合 MyKeymap
SetKeyDelay 0                                             ; 默认 10 太慢了, https://www.reddit.com/r/AutoHotkey/comments/gd3z4o/possible_unreliable_detection_of_the_keyup_event/
SetTitleMatchMode('Fast')
ProcessSetPriority "High"
FileEncoding("UTF-8")

class VimD {
    ;static charSplit := "※" ;分隔各命令
    /** @type {VimDWindow} */
    static curWin := {} ;记录当前的窗口，用来出错后 init
    static tipLevel := 15
    static tipLevel1 := 16 ;其他辅助显示

    /** @type {Map<String, VimDWindow>} */
    static wins := Map() ;在 initWin里设置

    static __New() {
        this.InitLogger()
    }

    static InitLogger() {
        logger.is_use_editor := true
        logger.is_out_console := true
        logger.is_out_file := false
        logger.set_pattern("[%Y-%m-%d %H:%M:%S.%F] [%=8l] [%5!ius] %^%v%$")
        logger.level := LogLevel.DEBUG
        logger.info("Logger initialized")
    }

    ;NOTE 核心，由各插件自行调用
    /**
     *
     * @param winName
     * @param winTitle
     * @param excludeTitle
     * @returns {VimDWindow}
     */
    static InitWin(winName, winTitle := "", excludeTitle := "") {
        ;msgbox(winName . "`n" . json.stringify(this.wins, 4))
        if !this.wins.has(winName)
            this.wins[winName] := VimDWindow(winName)
        /** @type {VimDWindow} */
        win := this.wins[winName]
        win.winTitle := winTitle
        win.excludeTitle := excludeTitle
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
