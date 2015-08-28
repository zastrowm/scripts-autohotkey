#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SleepLock := "True"
CurTimeIdle := 0
SetTimer, IdleChk, 60000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Auto Sleeping
;;;;;;;;;;; 

;Sleep when Idle
IdleChk:
; have we been idle for as least as many times as we've 'ticked'
if (A_TimeIdle > (CurTimeIdle * 60 * 1000)) and SleepLock <> "Off" {
  CurTimeIdle := (CurTimeIdle + 1)

  ; TrayTip, "Idle Time", "CurTimeIdle  = %CurTimeIdle%; A_TimeIdle = %A_TimeIdle%"

  ; after 30 minutes
  if (CurTimeIdle > 30) {
    ; reset the current idle time so that we don't get another notification
    CurTimeIdle := 0

    ; inform the user that the computer is going to sleep is 5 minutes
    MsgBox, 49, Going to go to sleep, The computer is going to sleep in 5 minutes, 300

    ; if either OK or the dialog Times out, go to sleep
    IfMsgBox OK
       DllCall("PowrProf\SetSuspendState", "int", 0, "int", 1, "int", 0)
    IfMsgBox TIMEOUT
       DllCall("PowrProf\SetSuspendState", "int", 0, "int", 1, "int", 0)
  }

} else {
  ; restart the watch
  CurTimeIdle := 0
}
RETURN

; Alt + Win + S
;Sleep lock, prevent from sleeping
!#s::
	if (SleepLock <> "On")
	{
		SleepLock := "On"
		TrayTip Enabling Sleep Mode, Sleep Mode is now Enabled, 5, 1
		
	} else {
		SleepLock := "Off"
		TrayTip Disabling Sleep Mode, Sleep Mode is now Disabled, 5, 1
		
	}
	Return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Sleep and Hibernation
;;;;;;;;;;;

;Ctrl + Windows + S = Sleep
^#S::
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
	Return


;Ctrl + Windows + Alt + S = Hibernate
!^#S::
	DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make the mouse back key work in visual studio
;;;;;;;;;;;;;;;;;;;;;;;;
XButton1::
	WinGet, active_id, ProcessName, A
	
	if (active_id = "devenv.exe")
	{
		Send {Control Down}-{Control Up}
		Return	
	}
	if (active_id = "WebStorm.exe")
	{
		Send {Control Down}{Alt Down}{Left}{Alt Up}{Control Up}
		Return	
	}
	
	Send {Browser_Back}
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make the mouse foward key work in visual studio
;;;;;;;;;;;;;;;;;;;;;;;;
XButton2::
	WinGet, active_id, ProcessName, A
	
	if (active_id = "devenv.exe")
	{
		Send {Control Down}{Shift Down}-{Shift Up}{Control Up}
		Return	
	}
	if (active_id = "WebStorm.exe")
	{
		Send {Control Down}{Alt Down}{Right}{Alt Up}{Control Up}
		Return	
	}
	
	Send {Browser_Forward}
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Paste Without Formatting
;;;;;;;;;;;;;;;;;;;;;;;;

+^v::                            ; Text–only paste from ClipBoard
   Clip0 = %ClipBoardAll%
   ClipBoard = %ClipBoard%       ; Convert to text
   Send ^v                       ; For best compatibility: SendPlay
   Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
   ClipBoard = %Clip0%           ; Restore original ClipBoard
   VarSetCapacity(Clip0, 0)      ; Free memory
Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Explorer/Command Prompt
;;;;;;;;;;;	
#e:: Run explorer.exe D:\
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Windows Key + C launches cmd prompt in current folder, or in D:/
#f1::
;;;;;;;;;;;	
defaultLocation = "D:/"
IfWinActive ahk_class CabinetWClass,,Address
{
	WinGetText, Title,,Address
	Position := inStr(Title,"`r") - 10
	Title := SubStr(Title,10,Position )		
	
	Run, D:\Programs\~shortcuts\startmintty.bat %defaultLocation% %Title%
	;MsgBox, '%defaultLocation%' '%Title%'
}
else
	Run, D:\Programs\~shortcuts\startmintty.bat %defaultLocation%
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WINDOWS KEY + A TOGGLES HIDDEN FILES 
;;;;;;;;;;;	
#a:: 
	RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden 
	If HiddenFiles_Status = 2  
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1 
	Else  
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2 
	WinGetClass, eh_Class,A 
	If (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA")
	send, {F5} 
	Else PostMessage, 0x111, 28931,,, A 
	Return
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#/::
;;;;;;;;;;;
	EnvUpdate
	TrayTip Environment Updated, Environment Updated, 5, 1
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WINDOWS KEY + Q TOGGLES FILE EXTENSIONS
;;;;;;;;;;;
#q::
	RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
	If HiddenFiles_Status = 1 
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0
	Else 
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 1
	WinGetClass, eh_Class,A
	If (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA")
	send, {F5}
	Else PostMessage, 0×111, 28931,,, A
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make caps lock an unindent key
;;;;;;;;;;;
Capslock::
	Send {Shift Down}{ESC}{Shift Up}
	return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Shift+CapsLock now enables/disable caps
;;;;;;;;;;;
+Capslock::Capslock

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Kill Windows Explorer (to fix occasional win7 glitch)
;;;;;;;;;;;
#K::
	Run, `D:\Programs\files\csscript\cscs.exe "D:\Programs\scripts\killexplorer.cs"`, Hide
	return
	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Control+V to paste in console 
;;;;;;;;;;;
#IfWinActive ahk_class ConsoleWindowClass
^V::
	SendInput {Raw}%clipboard%
	return
#IfWinActive