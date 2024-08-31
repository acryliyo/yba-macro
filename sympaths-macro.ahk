#Requires AutoHotkey v2.0
on := False
claws := "9" ; set this to the slot your claws are on
F4::{
    Global on := not on
    SoundBeep 1000 + 500 * on
}
#HotIf on
; change these keys to the keys you want binded to come after 9
OnKeyPress(ThisHotkey)
{
  SetKeyDelay 5,5
  While GetKeyState(SubStr(ThisHotkey,2), "P") 
  {
    Send '{' SubStr(ThisHotkey,2) '}'
    Sleep 50
  }
}
OnKeyPressClaws(ThisHotkey)
{
    Send claws
    Send StrLower(SubStr(ThisHotkey,2,1))
    ; MsgBox(StrLower(SubStr(ThisHotkey,2,1)))
    Send claws
}

*q::
*n::
*r::
*t::
*z::
*x::
*j::
*h::
*g::
*y:: {
    OnKeyPress(ThisHotkey)
}
*K::
*C::
*V::
*B::
*M::{
    OnKeyPressClaws(ThisHotkey)
}
#HotIf