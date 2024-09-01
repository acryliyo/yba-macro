#Requires AutoHotkey v2.0

window := Gui("Border","acry macro")
window.Add("Text","","boxing claws key: ")
claws := window.Add("Hotkey","vBoxingClawsKey")
window.Add("Text","","boxing keybinds: ")
boxingBinds := window.Add("Edit", "vBoxingKeybinds", "c,v,b,m,k")
window.Add("Text","","keys to macro (DO NOT PUT BOXING MOVES HERE): ")
keysToMacro := window.Add("Edit", "vKeysToMacro", "r,t,y,g,h,z,x,q")
window.Add("Text","","macro delay: ")
MacroDelay := window.Add("Edit", "vMacroDelay", "25")
boxingMacroActivated := window.Add("CheckBox", "vBoxingMacroActivated", "activate boxing macro")
macroActivated := window.Add("CheckBox", "vMacroActivated", "activate key macro")
WASDActivated := window.Add("CheckBox", "vWASDMacroActivated", "activate wasd macro")

keybinds := []

updKeybinds()
{
  Loop Keybinds.Length
  {
    if (!has(StrSplit(boxingBinds.Text,","),A_LoopField) and !has(StrSplit(keysToMacro.Text,","),A_LoopField)) {
      ; Hotkey Keybinds[A_Index], "Off"
      ; Keybinds.RemoveAt(A_Index)
    }
  }
}
has(haystack,needle)
{
  Loop haystack.Length
  {
    if (haystack[A_Index] == needle) {
      return true
    }
  }
  return false
}
Compare(a,b)
{
  return ("s" == a and "w" == b or "w" == a and "s" == b or "a" == a and "d" == b or "d" == a and "a" == b)
}
OnWASD(ThisHotkey)
{
  hotkeys := ["w","a","s","d"]
  For i in hotkeys {
    if (ThisHotkey != i) {
      if (!GetKeyState(i,"P")) {
        Send "{" . i . " up}"
      } else {
        if (Compare(i,ThisHotkey)) {
          Send "{" . i . " up}"
        }
      }
      
    } else {
      Send "{" . i . " down}"
      
    }
  }
}
OnWASDUp(ThisHotkey)
{
  Send "{" . ThisHotkey . "}"
  hotkeys := ["w","a","s","d"]
  For i in hotkeys {
    if (ThisHotkey != i) {
      if (GetKeyState(i,"P")) {
        Send "{" . i . " down}"
      }
    }
  }
}
OnKeyPress(ThisHotkey)
{
  if(!has(StrSplit(keysToMacro.Text,","),SubStr(ThisHotkey,2))) {
    Send "{" . SubStr(ThisHotkey,2) . " down}"
    While GetKeyState(SubStr(ThisHotkey,2), "P") 
    {
      Sleep 1
    }
    Send "{" . SubStr(ThisHotkey,2) . " up}"
    return
  }
  Send "{f up}"
  Send "{e up}"
  if(!GetKeyState("LAlt","P")) {
    Send "{alt up}"
  }
  
  SetKeyDelay 5,5
  While GetKeyState(SubStr(ThisHotkey,2), "P") 
  {
    if (GetKeyState(SubStr(ThisHotkey,2), "P")) {
      Send '{' SubStr(ThisHotkey,2) '}'
    }
    Sleep MacroDelay.Text
  }
}
OnKeyPressClaws(ThisHotkey)
{
  if(!has(StrSplit(boxingBinds.Text,","),SubStr(ThisHotkey,2))) {
    Send "{" . SubStr(ThisHotkey,2) . " down}"
    While GetKeyState(SubStr(ThisHotkey,2), "P") 
    {
      Sleep 1
    }
    Send "{" . SubStr(ThisHotkey,2) . " up}"
    return
  }
  Send "{f up}"
  Send "{e up}"
  Send "{alt Up}"
  Send claws.Value
  Send "{" . StrLower(SubStr(ThisHotkey,2,1)) . " down}"
  while (GetKeyState(SubStr(ThisHotkey,2,1),"P")) {
    Sleep 5
  }
  Send "{" . StrLower(SubStr(ThisHotkey,2,1)) . " up}"
  ; MsgBox(StrLower(SubStr(ThisHotkey,2,1)))
  Send claws.Value
}

SetMacroKeys(awd,awd2) 
{
  global
  
  updKeybinds()
  
  Loop Parse, keysToMacro.Text, "," {
      HotIf hk => macroActivated.Value
      MacroName := "*" . A_LoopField
      Hotkey(MacroName,OnKeyPress, "On")
      keybinds.push(MacroName)
      HotIf
  }
}
SetClawsMacro(awd,awd2) 
{
  global

  updKeybinds()
  
  Loop Parse, boxingBinds.Text, "," {
      HotIf hk => boxingMacroActivated.Value
      MacroName := "*" . A_LoopField
      Hotkey MacroName,OnKeyPressClaws, "On"
      keybinds.push(MacroName)
      HotIf
  }
}

WASDActivated_Click(awd,awd2) {
  global
  characters := "w,a,s,d"
  Loop Parse, characters, "," {
      HotIf hk => WASDActivated.Value
      MacroName := A_LoopField
      MacroUp := MacroName . " up"
      Hotkey MacroName,OnWASD
      Hotkey MacroUp,OnWASDUp
      HotIf
  }
}
macroActivated.OnEvent("Click",SetMacroKeys)
boxingMacroActivated.OnEvent("Click",SetClawsMacro)
keysToMacro.OnEvent("LoseFocus",SetMacroKeys)
boxingBinds.OnEvent("LoseFocus",SetClawsMacro)
WASDActivated.OnEvent("Click",WASDActivated_Click)

window.Show()
OnClose(asd)
{
  ExitApp
}
window.OnEvent("Close",OnClose)