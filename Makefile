GHC:=ghc
EXE:=xmonad-x86_64-linux


all:
	$(GHC) xmonad.hs -o $(EXE) && mv $(EXE) ~/.xmonad/.
