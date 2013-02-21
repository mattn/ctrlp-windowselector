if exists('g:loaded_ctrlp_windowselector') && g:loaded_ctrlp_windowselector
  finish
endif
let g:loaded_ctrlp_windowselector = 1

let s:windowselector_var = {
\  'init':   'ctrlp#windowselector#init()',
\  'accept': 'ctrlp#windowselector#accept',
\  'lname':  'windowselector',
\  'sname':  'windowselector',
\  'type':   'windowselector',
\  'sort':   0,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:windowselector_var)
else
  let g:ctrlp_ext_vars = [s:windowselector_var]
endif

function! ctrlp#windowselector#init()
  let windows = []
python <<EOF
import vim, win32gui
def winfun(hwnd, lparam):
  if win32gui.IsWindowVisible(hwnd):
    title = win32gui.GetWindowText(hwnd)
    if len(title):
      vim.command("call add(l:windows, '%s')" % ("%s\t%d" % (title, hwnd)).replace("\\", "\\\\").replace("'", "''"))
      return 1
win32gui.EnumChildWindows(None, winfun, None)
EOF
  return windows
endfunc

function! ctrlp#windowselector#accept(mode, str)
  let window = matchstr(a:str, '^.*\t\zs\d\+$') + 0
  call ctrlp#exit()
python <<EOF
win32gui.SetForegroundWindow(int(vim.eval('l:window')))
EOF
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#windowselector#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
