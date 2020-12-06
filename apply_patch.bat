SET ROM_DIR=C:\Users\grego\Desktop\MAME\roms

del build\sfzch_hack.bin
copy build\sfzch.bin build\sfzch_hack.bin

Asm68k.exe /p hack_test.asm, build\sfzch_hack.bin

del build\out\sfzch23
del build\out\sfza22
del build\out\sfzch21
del build\out\sfza20

java -jar RomMangler.jar split sfzch_out_split.cfg build\sfzch_hack.bin

del %ROM_DIR%\sfzch_cps15.zip

java -jar RomMangler.jar zipdir build\out %ROM_DIR%\sfzch_cps15.zip