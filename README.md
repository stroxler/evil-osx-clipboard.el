# OSX clipboard copy-paste handlers for evil users

If you use terminal `vim` or one of the more popular gui vims (e.g. `gvim` or
`MacVim`), you are likely to be used to the following behavior: normal system
default copy-paste commands - e.g.  `COMMAND c` and `COMMAND v` on mac, use the
sytem clipboard but typical vim commands do not.

I like this behavoir since it makes it easy to use vim with other applications
via system clipboard integration, but it prevents my editor from clobbering
my system clipboard every time I change a word (which particularly matters to
me since I use `clipmenu`, an awesome OSX clipboard history manager).

This package provides functions `evil-system-clipboard/copy` and
`evil-system-clipboard/paste` to copy/paste using the clipboard, but
ensure that `pbcopy` is always set off at the end of the command.

You can either manually bind these interactive functions, or if you want
reasonable default settings for osx you can call either
```
(evil-system-clipboard/set-osx-defaults)
```
in your emacs init file. You'll also likely want to ensure that
`pbcopy` is off by default by calling `(turn-off-pbcopy)`.


## Developer notes

This is my first package, so I'm still getting used to elisp. I have
a dependency on `evil` and `pbcopy`, but I don't know how to directly
declare this. So at the moment, my package throws a warning at compile
time that it can't be sure `turn-(on|off)-pbcopy` exists, but everything
actually works as long as you've got `pbcopy` loaded.

Pull requests fixing this properly are welcome.
