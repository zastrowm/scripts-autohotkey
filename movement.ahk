
SetTitleMatchMode, 2

#IfWinActive, ahk_exe devenv.exe
^K::
  Send, {Down}
  return
  
#IfWinActive, ahk_exe devenv.exe
^J::
  Send, {Up}
  return
  
#IfWinActive, ahk_exe devenv.exe
^H::
  Send, {Left}
  return
  
#IfWinActive, ahk_exe devenv.exe
^L::
  Send, {Right}
  return