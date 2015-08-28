
SetTitleMatchMode, 2

#IfWinActive, Microsoft Visual Studio
^K::
  Send, {Down}
  return
  
#IfWinActive, Microsoft Visual Studio
^J::
  Send, {Up}
  return
  
#IfWinActive, Microsoft Visual Studio
^H::
  Send, {Left}
  return
  
#IfWinActive, Microsoft Visual Studio
^L::
  Send, {Right}
  return