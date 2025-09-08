## 两次

hotif 如果失败，会进行第二次检查！https://deepwiki.com/search/hotif_20ee5bc3-c28d-45cb-a314-a34ee21494fa

https://github.com/AutoHotkey/AutoHotkey/blob/da0a168198886972934f17dd47edd1ff1585d4d4/source/application.cpp#L830
The inefficiency of calling HotCriterionAllowsFiring() twice for each hotkey --
 once in the hook and again here -- seems justified for the following reasons:
 - It only happens twice if the hotkey a hook hotkey (multi-variant keyboard hotkeys
   that have a global variant are usually non-hook, even on NT/2k/XP).
 - The hook avoids doing its first check of WinActive/Exist if it sees that the hotkey
   has a non-suspended, global variant.  That way, hotkeys that are hook-hotkeys for
   reasons other than `#HotIf` Win. (such as mouse, overriding OS hotkeys, or hotkeys
   that are too fancy for RegisterHotkey) will not have to do the check twice.
 - It provides the ability to set the last-found-window for `#HotIf` WinActive/Exist
   (though it's not needed for the "Not" counterparts).  This HWND could be passed
   via the message, but that would require malloc-there and free-here, and might
   result in memory leaks if its ever possible for messages to get discarded by the OS.
 - It allows hotkeys that were eligible for firing at the time the message was
   posted but that have since become ineligible to be aborted.  This seems like a
   good precaution for most users/situations because such hotkey subroutines will
   often assume (for scripting simplicity) that the specified window is active or
   exists when the subroutine executes its first line.
 - Most criterion hotkeys use `#HotIf` WinActive(), which is a very fast call.  Also, although
   WinText and/or "SetTitleMatchMode 'Slow'" slow down window searches, those are rarely
   used too.
