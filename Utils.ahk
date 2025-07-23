#Requires AutoHotkey v2.0

icons := {
    "left": "←",
    "right": "→",
    "up": "↑",
    "down": "↓",
    "space": "␣",
    "enter": "↵",
    "tab": "⇥",
    "backspace": "⌫",
    "delete": "⌦",
}

Obj2Str(obj) {
    return JSON.stringify(obj, 4)
}

Objs2Str(objs*) {
    result := ""
    for _, obj in objs {
        result .= Obj2Str(obj) . "`n"
    }
    return result
}

class KeyUtil {
    /**
     * @description 将大写字母转换为小写字母前加 + 号
     * G -> +g
     */
    static Lhs2Hot(lhs) {
        if (lhs ~= "^[A-Z]$") {
            return "+" . StrLower(lhs)
        }
        return lhs
    }

    /**
     * 如果是+g，返回 G
     */
    static Hot2Visual(hot) {
        if (hot ~= "^\+[a-z]$") {
            return StrUpper(substr(hot, -1))
        }
        return hot
    }
}
