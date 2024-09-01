#Requires AutoHotkey v2.0
on := False
claws := "9" ; set this to the slot your claws are on
F4::{
    Global on := not on
    SoundBeep 1000 + 500 * on
}
#HotIf on
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
  Send "{f up}"
  if(!GetKeyState("LAlt","P")) {
    Send "{alt up}"
  }
  
  SetKeyDelay 5,5
  While GetKeyState(SubStr(ThisHotkey,2), "P") 
  {
    if (GetKeyState(SubStr(ThisHotkey,2), "P")) {
      Send '{' SubStr(ThisHotkey,2) '}'
    }
    Sleep 5
  }
}
OnKeyPressClaws(ThisHotkey)
{
    Send "{f up}"
    Send "{alt Up}"
    Send claws
    Send StrLower(SubStr(ThisHotkey,2,1))
    ; MsgBox(StrLower(SubStr(ThisHotkey,2,1)))
    Send claws
}
; change these keys to the ones you want macrod
*q::
*n::
*r::
*t::
*z::
*x::
*j::
*h::
*g::
*LAlt::
*y:: {
    OnKeyPress(ThisHotkey)
}
; change these keys to the boxing moves
*K::
*C::
*V::
*B::
*M::{
    OnKeyPressClaws(ThisHotkey)
}
w::
a::
s::
d::{
  OnWASD(ThisHotkey)
}
w up::
a up::
s up::
d up::{
  OnWASDUp(ThisHotkey)
}
#HotIf
