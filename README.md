# StickyPin

Стикеры (sticky) на рабочий стол (windows) с возможностью закрепиться поверх всех окон (pin).

![GUI](https://secator.com/files/stickypin/gui.png)


# Компиляция

Необходимо [Windows SDK](https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/)

```
ml64.exe /Fo"main.obj" /Zp16 main.asm
```
```
link.exe^
 /OUT:"StickyPin.exe"^
 "user32.lib"^
 "kernel32.lib"^
 "gdi32.lib"^
 "shell32.lib"^
 /ASSEMBLYDEBUG:DISABLE /SUBSYSTEM:WINDOWS /ENTRY:"main" /MACHINE:X64 main.obj
```

# Или готовое

[Релиз на GitVerse](https://gitverse.ru/secator/stickypin/releases)
