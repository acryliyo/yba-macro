#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 1
; TODO: FIX KEYS STILL BEING HELD DOWN
window := Gui("Border","acry macro")
window.Add("Text","","boxing claws key: ")
claws := window.Add("Edit","vclaws")
window.Add("Text","","boxing keybinds: ")
boxingBinds := window.Add("Edit", "vboxingBinds", "")
window.Add("Text","","keys to macro (DO NOT PUT BOXING MOVES HERE): ")
keysToMacro := window.Add("Edit", "vkeysToMacro", "")
window.Add("Text","","macro delay: ")
MacroDelay := window.Add("Edit", "vMacroDelay", "")
boxingMacroActivated := window.Add("CheckBox", "vBoxingMacroActivated", "activate boxing macro")
macroActivated := window.Add("CheckBox", "vMacroActivated", "activate key macro (WARNING: BUGGY)")
undoActivated := window.Add("CheckBox", "vUnBarrageActivated", "activate unbarrage/block macro")
WASDActivated := window.Add("CheckBox", "vWASDMacroActivated", "activate wasd macro (WARNING: BUGGY)")
window.Add("Text","","Deactivation hotkey: ")
DeactivateHotkey := window.Add("Hotkey", "vWASDDeactivateHotkey")
QuickDeactivate := window.Add("CheckBox", "vQuickDeactivate", "Quick Activate/deactivate (same as deactivation hotkey)")
LoadConfigButton := window.Add("Button","vLoadConfig","Load Config")
window.Add("Text","","If you name the config defaultConfig.txt then it autoloads it")
SaveConfigButton := window.Add("Button","vSaveConfig","Save Config")

CurrentDeactivationHotkey := ""
keybindsActive := []
QuickSettings := []
boxingGlovesActive := false

setting(gui) 
{
  if (gui.Value) {
    QuickSettings.Push(gui)
  }
}
QuickActivate(activated)
{
  global

  if(activated) {
    for i, v in QuickSettings
    {
      v.Value := true
    }
  } else {
    QuickSettings := []
    setting(boxingMacroActivated)
    setting(macroActivated)
    setting(undoActivated)
    setting(WASDActivated)
    for i, v in QuickSettings
    {
      v.Value := false
    }
  }
  SetClawsMacro(1,2)
  SetMacroKeys(1,2)
}
QuickActivateKeybind(a)
{
  global
  QuickDeactivate.Value := !QuickDeactivate.Value
  QuickActivate(QuickDeactivate.Value)
}
OnActivateHotkeyPress(a,b)
{
  global
  if (CurrentDeactivationHotkey != "") {
    Hotkey DeactivateHotkey.Value,QuickActivateKeybind, "Off"
  }
  Hotkey DeactivateHotkey.Value, QuickActivateKeybind
  CurrentDeactivationHotkey := DeactivateHotkey.Value
}
OnQuickActivateToggle(a,b)
{
  QuickActivate(QuickDeactivate.Value)
}
loadConfig(fileName)
{
  SelectedFile := ""
  if(fileName == "") {
    path := FileSelect(0,A_WorkingDir)
    SelectedFile := FileOpen(path,"r")
  } else {
    SelectedFile := FileOpen(fileName,"r")
  }
  config := SelectedFile.Read()
  configs := StrSplit(config,"`n")
  for index, setting in configs {
    ; SubStr(setting,1,-1)
    aa1 := StrSplit(setting,"|")
    if(aa1.Get(1) == "claws") {
      claws.Text := aa1.Get(2)
    } else if (aa1.Get(1) == "boxingBinds") {
      boxingBinds.Text := aa1.Get(2)
    } else if (aa1.Get(1) == "keysToMacro") {
      keysToMacro.Text := aa1.Get(2)
    } else if (aa1.Get(1) == "MacroDelay") {
      MacroDelay.Text := StrSplit(setting,"|").Get(2)
    }
  }
}
if (FileExist("defaultConfig.txt")) {
  loadConfig("defaultConfig.txt")
}
LoadConfigClick(awd1,awd2)
{
  loadConfig("")
}
LoadConfigButton.OnEvent("Click",LoadConfigClick)
SaveConfigClick(awd1,awd2)
{
  filename := FileSelect("S",A_WorkingDir,,"Text Files (*.txt)") 
  if(filename) {
    FileAppend(Format("claws|{1:s}`nboxingBinds|{2:s}`nkeysToMacro|{3:s}`nMacroDelay|{4:s}",claws.Text,boxingBinds.Text,keysToMacro.Text,MacroDelay.Text),filename . ".txt")
  }
}
SaveConfigButton.OnEvent("Click",SaveConfigClick)

search(haystack,needle)
{
  Loop haystack.Length
    {
      if (haystack[A_Index] == needle) {
        return A_Index
      }
    }
    return -1
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
        SendInput "{Blind}{" . i . " up}"
      } else {
        if (Compare(i,ThisHotkey)) {
          SendInput "{Blind}{" . i . " up}"
        }
      }
      
    } else {
      SendInput "{Blind}{" . i . " down}"
    }
  }
}
OnWASDUp(ThisHotkey)
{
  SendInput "{Blind}{" . ThisHotkey . "}"
  hotkeys := ["w","a","s","d"]
  For i in hotkeys {
    if (ThisHotkey != i) {
      if (GetKeyState(i,"P")) {
        SendInput "{Blind}{" . i . " down}"
      }
    }
  }
}
OnKeyPress(ThisHotkey)
{
  SetKeyDelay 25,25
  if(has(keybindsActive,SubStr(ThisHotkey,2))) {
    return
  }
  if(!has(StrSplit(keysToMacro.Text,","),SubStr(ThisHotkey,2)) and macroActivated) {
    SendInput "{Blind}{" . SubStr(ThisHotkey,2) . " down}"
    While GetKeyState(SubStr(ThisHotkey,2), "P") 
    {
      Sleep 1
    }
    SendInput "{Blind}{" . SubStr(ThisHotkey,2) . " up}"
    return
  }
  if (undoActivated.Value) {
    SendInput "{f up}"
    SendInput "{e up}"
  }
  if(GetKeyState("LAlt","P")) {
    SendInput "{alt up}"
  }
  if(macroActivated.Value) {
    keybindsActive.push(SubStr(ThisHotkey,2))
    While GetKeyState(SubStr(ThisHotkey,2), "P") 
    {
      if (GetKeyState(SubStr(ThisHotkey,2), "P")) {
        SendInput '{Blind}{' SubStr(ThisHotkey,2) ' down}'
      } else {
        break
      }
      Sleep MacroDelay.Text
    }
    keybindsActive.RemoveAt(search(keybindsActive,SubStr(ThisHotkey,2)))
  } else {
    SendInput "{Blind}{" . SubStr(ThisHotkey,2) . " down}"
    While GetKeyState(SubStr(ThisHotkey,2), "P") 
    {
      Sleep 1
    }
    SendInput "{Blind}{" . SubStr(ThisHotkey,2) . " up}"
    return
  }
  return
}
OnKeyPressClaws(ThisHotkey)
{
  global

  if(!has(StrSplit(boxingBinds.Text,","),SubStr(ThisHotkey,2))) {
    SendInput "{Blind}{" . SubStr(ThisHotkey,2) . " down}"
    While GetKeyState(SubStr(ThisHotkey,2), "P") 
    {
      Sleep 1
    }
    SendInput "{Blind}{" . SubStr(ThisHotkey,2) . " up}"
    return
  }
  SendInput "{f up}"
  SendInput "{e up}"
  if(GetKeyState("LAlt","P")) {
    SendInput "{alt up}"
  }
  SendInput claws.Text
  SendInput "{Blind}{" . StrLower(SubStr(ThisHotkey,2,1)) . "}"
  ; MsgBox(StrLower(SubStr(ThisHotkey,2,1)))
  SendInput claws.Text
  return
}

SetMacroKeys(awd,awd2) 
{
  global
  
  Loop Parse, keysToMacro.Text, "," {
      MacroName := "*" . A_LoopField
      Hotkey MacroName,OnKeyPress
  }
}
SetClawsMacro(awd,awd2) 
{
  global
  
  Loop Parse, boxingBinds.Text, "," {
      HotIf hk => boxingMacroActivated.Value
      MacroName := "*" . A_LoopField
      Hotkey MacroName,OnKeyPressClaws
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
DeactivateHotkey.OnEvent("Change",OnActivateHotkeyPress)
undoActivated.OnEvent("Click",SetMacroKeys)
boxingMacroActivated.OnEvent("Click",SetClawsMacro)
keysToMacro.OnEvent("LoseFocus",SetMacroKeys)
boxingBinds.OnEvent("LoseFocus",SetClawsMacro)
WASDActivated.OnEvent("Click",WASDActivated_Click)
QuickDeactivate.OnEvent("Click",OnQuickActivateToggle)

window.Show()
OnClose(asd)
{
  ExitApp
}
window.OnEvent("Close",OnClose)
