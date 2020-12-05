SET ROM_DIR=C:\Users\grego\Desktop\MAME\roms

del build\sfzch_hack.bin
copy build\sfzch.bin build\sfzch_hack.bin

Asm68k.exe /p  hack_test.asm, build\sfzch_hack.bin
