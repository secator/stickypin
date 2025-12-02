;
; Name: StickyPin
; Version: 0.0.1
; Date: 20-11-2025
; Author: secator
; URL: https://secator.com/stickypin/
;

includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib
includelib shell32.lib

include windows.inc

extern GetModuleHandleW:proc
extern SystemParametersInfoW:proc
extern GetSystemMetrics:proc
extern GetModuleFileNameW:proc
extern GetDlgCtrlID:proc
extern GetDlgItem:proc
extern GetParent:proc
extern CreatePen:proc
extern CreateSolidBrush:proc
extern CreateCompatibleDC:proc
extern DeleteDC:proc
extern CreateCompatibleBitmap:proc
extern FillRect:proc
extern SelectObject:proc
extern DeleteObject:proc
extern CreateIconIndirect:proc
extern MoveToEx:proc
extern LineTo:proc
extern GetClientRect:proc
extern GetWindowRect:proc
extern BeginPaint:proc
extern EndPaint:proc
extern LoadCursorW:proc
extern RegisterClassW:proc
extern CreateWindowExW:proc
extern CreateFontW:proc
extern ShowWindow:proc
extern SetForegroundWindow:proc
extern SetFocus:proc
extern SetWindowPos:proc
extern SetBkColor:proc
extern Shell_NotifyIconW:proc
extern GetMessageW:proc
extern TranslateMessage:proc
extern DispatchMessageW:proc
extern DefWindowProcW:proc
extern PostQuitMessage:proc
extern SendMessageW:proc
extern MessageBoxA:proc
extern GetSystemTime:proc
extern GetWindowTextW:proc
extern SetWindowTextW:proc
extern WritePrivateProfileStringW:proc
extern GetPrivateProfileSectionNamesW:proc
extern GetPrivateProfileStringW:proc
extern GetPrivateProfileIntW:proc
extern ExitProcess:proc

extern wsprintfW:proc
extern GetLastError:proc

.data
    about db "About", 0
    copyright db "Name: StickyPin", 13
              db "Version: 0.0.1 (20-11-2025)", 13
              db "Copyright: secator", 13
              db "URL: https://secator.com/s", 13
              dw 0, 0

    mainClass dw "M","A","I","N", 0
    stickyClass dw "S","T","I","C","K","Y", 0
    buttonClass dw "B","U","T","T","O","N", 0
    editClass dw "E","D","I","T",0

    font dw "V","e","r","d","a","n","a", 0

    ext dw "i","n","i", 0

    pin dw "p","i","n", 0
    x dw "x", 0, X_DEFAULT, 0
    y dw "y", 0, Y_DEFAULT, 0
    w dw "w", 0, W_DEFAULT, 0
    h dw "h", 0, H_DEFAULT, 0
    text dw "t","e","x","t", 0

    decimal dw "%","d", 0
    hexadecimal dw "%","0","2","X", 0
    id dw "%","d","-","%","0","2","d","-","%","0","2","d","|","%","0","2","d",":","%","0","2","d",":","%","0","2","d",".","%","d", 0

    iconTray db 5
          _LINE <ICON_PEN, BUTTON_WH / 3, ICON_PEN, BUTTON_WH - ICON_PEN>
          _LINE <ICON_PEN, BUTTON_WH - ICON_PEN, BUTTON_WH - ICON_PEN, BUTTON_WH - ICON_PEN>
          _LINE <BUTTON_WH - ICON_PEN, BUTTON_WH - ICON_PEN, BUTTON_WH - ICON_PEN, BUTTON_WH / 3>
          _LINE <BUTTON_WH - ICON_PEN, BUTTON_WH / 3, ICON_PEN, BUTTON_WH / 3>
          _LINE <BUTTON_WH * 3 / 4, ICON_PEN, BUTTON_WH / 3, BUTTON_WH * 3 / 4>

    iconPin db 5
          _LINE <ICON_PADDING, BUTTON_WH - ICON_PADDING, BUTTON_WH / 2, BUTTON_WH / 2>
          _LINE <ICON_PADDING, BUTTON_WH / 2, BUTTON_WH / 2, BUTTON_WH - ICON_PADDING>
          _LINE <ICON_PADDING, BUTTON_WH / 2, BUTTON_WH / 2, ICON_PADDING>
          _LINE <BUTTON_WH / 2, BUTTON_WH - ICON_PADDING, BUTTON_WH-ICON_PADDING, BUTTON_WH / 2>
          _LINE <BUTTON_WH / 2, ICON_PADDING, BUTTON_WH - ICON_PADDING + 1, BUTTON_WH / 2 + 1>

    iconPlus db 2
          _LINE <BUTTON_WH / 2, ICON_PADDING, BUTTON_WH / 2, BUTTON_WH - ICON_PADDING>
          _LINE <ICON_PADDING, BUTTON_WH / 2, BUTTON_WH - ICON_PADDING, BUTTON_WH / 2>

    iconExit db 2
          _LINE <ICON_PADDING, ICON_PADDING, BUTTON_WH - ICON_PADDING, BUTTON_WH - ICON_PADDING>
          _LINE <BUTTON_WH - ICON_PADDING, ICON_PADDING, ICON_PADDING, BUTTON_WH - ICON_PADDING>

    action _ACTION <>
         _ACTION <WM_CLOSE, 0, 0>
         _ACTION <WM_STICKY_PIN, 0, 0>

.data?
    hInstance dq ?
    hDC dq ?
    hBackground dq ?
    hCursor dq ?
    hPen dq ?

    file dw 256 dup (?)

    time _SYSTEMTIME <>

    msg _MSG <>

    sticky _STICKY <>
    workarea _RECT <>
    rect _RECT <>
    paint _PAINT <>
    nid _NOTIFYICONDATAA <>
    ii _ICONINFO <>

    mainWnd _WNDCLASSW <>
    stickyWnd _WNDCLASSW <>
    buttonWnd _WNDCLASSW <>

    buffer dw STICKY_LENGTH*4+4 dup (?)
    sections dw sizeof _STICKY.id*20 dup (?)

.code

main proc
    mov rbp, rsp
    sub rsp, 28h

    xor rcx, rcx
    call GetModuleHandleW
    mov [hInstance], rax

    call resourcesInit

    mov qword ptr [rsp + 20h], CW_USEDEFAULT
    mov qword ptr [rsp + 28h], CW_USEDEFAULT
    mov qword ptr [rsp + 30h], 0
    mov qword ptr [rsp + 38h], 0
    mov qword ptr [rsp + 40h], 0
    mov qword ptr [rsp + 48h], 0
    mov rcx, [hInstance]
    mov qword ptr [rsp + 50h], rcx
    mov qword ptr [rsp + 58h], 0
    xor rcx, rcx
    lea rdx, [mainClass]
    xor r8, r8
    xor r9, r9
    call CreateWindowExW

    mov rcx, NIM_ADD
    mov [nid.cbSize], sizeof _NOTIFYICONDATAA
    mov [nid.hWnd], rax
    mov [nid.uFlags], NIF_ICON or NIF_MESSAGE or NIF_TIP
    mov [nid.uCallbackMessage], WM_NOTIFY_ICON
    lea rdx, [nid]
    call Shell_NotifyIconW

    lea rcx, [sections]
    mov rdx, sizeof sections
    lea r8, [file]
    call GetPrivateProfileSectionNamesW
    test rax, rax
    jz @message

    lea r14, [sections]
    mov r15, rax

@next:
    xor rax, rax
    mov rdi, r14
    push rdi
    mov rcx, r15
    repnz scasw

    sub r15, rcx
    xchg r15, rcx
    lea rdi, [sticky.id]
    pop rsi
    rep movsw
    mov r14, rsi

    mov word ptr [sticky.pin], 0
    lea rcx, [sticky.id]
    lea rdx, [pin]
    mov r8, PIN_DEFAULT
    lea r9, [file]
    call GetPrivateProfileIntW
    cmp al, 1
    jnz @unpinned
    mov byte ptr [sticky.pin], "1"

@unpinned:
    xor r13, r13

@rect:
    ; x, y, w, h
    lea rcx, [sticky.id]
    lea rdx, [x]
    lea rdx, [rdx + r13 * 8]
    movzx r8, word ptr [rdx + 4]
    lea r9, [file]
    call GetPrivateProfileIntW
    lea rdx, [sticky.x]
    mov [rdx + r13 * 4], eax

    inc r13
    cmp r13, 4
    jnz @rect

    mov [sticky.text], 0

    lea rcx, [sticky.id]
    lea rdx, [text]
    xor r8, r8
    lea r9, [buffer]
    mov qword ptr [rsp + 20h], sizeof buffer
    lea rax, [file]
    mov qword ptr [rsp + 28h], rax
    call GetPrivateProfileStringW

    ; length/2
    test rax, 1
    jnz @bad
    ; length/4
    test rax, 2
    jnz @bad

    xor rdx, rdx
    lea rsi, [buffer]
    lea rdi, [sticky.text]

    ; STR to HEX
@lodsd:
    lodsd
    test al, al
    jz @break

@byte:
    ; 0-9
    rol dl, 4
    sub al, 30h
    cmp al, 9
    jbe @decimal

    ; A-F
    sub al, 7
    cmp al, 0Ah
    jb @break
    cmp al, 0Fh
    ja @break

@decimal:
    or dl, al
    shr eax, 10h
    jnz @byte

    xchg al, dl
    stosb
    jmp @lodsd

@break:
    xor eax, eax
    stosw

@bad:
    xor rcx, rcx
    call stickyCreate

    test r15, r15
    jnz @next

@message:
    lea rcx, [msg]
    xor rdx, rdx
    xor r8, r8
    xor r9, r9
    call GetMessageW
    test rax, rax
    jz @exit

    lea rcx, [msg]
    call TranslateMessage

    lea rcx, [msg]
    call DispatchMessageW
    jmp @message

@exit:
    mov rcx, rax
    call ExitProcess

    mov rsp, rbp
    pop rbp
    ret

main endp

resourcesInit proc
    push rbp
    mov rbp, rsp
    sub rsp, 60h

    ; default XY (right-bottom main monitor)
    mov rcx, SPI_GETWORKAREA
    xor rdx, rdx
    lea r8, [workarea]
    xor r9, r9
    call SystemParametersInfoW
    test rax, rax
    jz @skip
    sub [workarea.right], W_DEFAULT
    sub [workarea.bottom], H_DEFAULT

@skip:
    ; sticky file
    xor rcx, rcx
    lea rdx, [file]
    mov r8, 255
    call GetModuleFileNameW

    lea rdx, [file]
    lea rdx, [rdx + rax * 2 - 6]
    mov rax, qword ptr [ext]
    mov qword ptr [rdx], rax

    ; icon tray
    mov rcx, 0FFFFFFh
    call CreateSolidBrush
    mov [hBackground], rax

    lea r15, [ii.hbmMask]

@layer:
    xor rcx, rcx
    call CreateCompatibleDC
    mov [hDC], rax

    mov rcx, [hDC]
    mov rdx, 32
    mov r8, 32
    call CreateCompatibleBitmap
    mov [r15], rax

    mov rcx, [hDC]
    mov rdx, [r15]
    call SelectObject

    mov r13, 0FFFFFFh
    lea r14, [ii.hbmColor]
    cmp r15, r14
    jz @color

    mov rcx, [hDC]
    mov [rect.left], 0
    mov [rect.top], 0
    mov [rect.right], 32
    mov [rect.bottom], 32
    lea rdx, [rect]
    mov r8, [hBackground]
    call FillRect

    not r13

@color:
    mov rcx, PS_SOLID
    mov rdx, ICON_PEN
    mov r8, r13
    call CreatePen
    mov [hPen], rax

    mov rcx, [hDC]
    mov rdx, rax
    call SelectObject

    lea r14, [iconTray]
    mov r12, [hDC]
    call lineFromTo

    mov rcx, [hDC]
    call DeleteDC

    mov rcx, [hPen]
    call DeleteDC

    add r15, 8
    lea r14, [ii.hbmColor + 8]
    cmp r15, r14
    jnz @layer

    mov [ii.fIcon], 1
    lea rcx, [ii]
    call CreateIconIndirect
    mov [nid.hIcon], rax

    mov rcx, [hBackground]
    call DeleteObject

    ; classes
    xor ecx, ecx
    mov edx, IDC_ARROW
    call LoadCursorW
    mov [hCursor], rax

    ; main, for tray
    mov rcx, [hInstance]
    mov qword ptr [mainWnd.hInstance], rcx
    mov dword ptr [mainWnd.style], CS_HREDRAW or CS_VREDRAW
    mov rcx, offset mainProc
    mov qword ptr [mainWnd.lpfnWndProc], rcx
    mov qword ptr [mainWnd.hCursor], rax
    mov rcx, offset mainClass
    mov qword ptr [mainWnd.lpszClassName], rcx
    lea rcx, [mainWnd]
    call RegisterClassW

    ; sticky
    mov rcx, BACKGROUND
    call CreateSolidBrush
    mov [hBackground], rax

    mov qword ptr [stickyWnd.hbrBackground], rax
    mov rcx, [hInstance]
    mov qword ptr [stickyWnd.hInstance], rcx
    mov dword ptr [stickyWnd.style], CS_HREDRAW or CS_VREDRAW
    mov rcx, offset stickyProc
    mov qword ptr [stickyWnd.lpfnWndProc], rcx
    mov rcx, [hCursor]
    mov qword ptr [stickyWnd.hCursor], rcx
    mov rcx, offset stickyClass
    mov qword ptr [stickyWnd.lpszClassName], rcx
    lea rcx, [stickyWnd]
    call RegisterClassW

    ; button
    mov rcx, [hInstance]
    mov qword ptr [buttonWnd.hInstance], rcx
    mov dword ptr [buttonWnd.style], CS_HREDRAW or CS_VREDRAW
    mov rcx, offset buttonProc
    mov qword ptr [buttonWnd.lpfnWndProc], rcx
    mov rcx, [hCursor]
    mov qword ptr [buttonWnd.hCursor], rcx
    mov rcx, offset buttonClass
    mov qword ptr [buttonWnd.lpszClassName], rcx
    lea rcx, [buttonWnd]
    call RegisterClassW

    mov rsp, rbp
    pop rbp
    ret
resourcesInit endp

mainProc proc
    push rbp
    mov rbp, rsp
    sub rsp, 60h

    mov [rbp + 10h], rcx    ; hwnd
    mov [rbp + 18h], rdx    ; msg
    mov [rbp + 20h], r8     ; wParam
    mov [rbp + 28h], r9     ; lParam

    cmp rdx, WM_NOTIFY_ICON
    jnz @continue

    cmp r9, WM_MBUTTONDOWN
    jz @WM_MBUTTONDOWN
    cmp r9, WM_RBUTTONDOWN
    jz @WM_RBUTTONDOWN
    cmp r9, WM_LBUTTONDOWN
    jnz @continue

@WM_LBUTTONDOWN:
    mov rcx, 1
    call stickyCreate
    jmp @exit

@WM_MBUTTONDOWN:
    call messageAbout
    jmp @exit

@WM_RBUTTONDOWN:
    xor rcx, rcx
    call PostQuitMessage

@exit:
    mov rsp, rbp
    pop rbp
    ret

@continue:
    mov rcx, [rbp + 10h]
    mov rdx, [rbp + 18h]
    mov r8, [rbp + 20h]
    mov r9, [rbp + 28h]
    call DefWindowProcW
    jmp @exit
mainProc endp


stickyProc proc
    push rbp
    mov rbp, rsp
    sub rsp, 70h

    mov [rbp + 10h], rcx    ; hwnd
    mov [rbp + 18h], rdx    ; msg
    mov [rbp + 20h], r8     ; wParam
    mov [rbp + 28h], r9     ; lParam

    cmp rdx, WM_COMMAND
    jz @WM_COMMAND
    cmp rdx, WM_CTLCOLOREDIT
    jz @WM_CTLCOLOREDIT
    cmp rdx, WM_MOUSEMOVE
    jz @WM_MOUSEMOVE
    cmp rdx, WM_GETMINMAXINFO
    jz @WM_GETMINMAXINFO
    cmp rdx, WM_STICKY_PIN
    jz @WM_STICKY_PIN
    cmp rdx, WM_SETFOCUS
    jz @WM_SETFOCUS
    cmp rdx, WM_WINDOWPOSCHANGED
    jz @WM_WINDOWPOSCHANGED
    cmp rdx, WM_CREATE
    jnz @continue

@WM_CREATE:
    ; add button
    mov qword ptr [rsp + 20h], BUTTON_WH + BORDER
    mov qword ptr [rsp + 28h], BORDER
    mov qword ptr [rsp + 30h], BUTTON_WH
    mov qword ptr [rsp + 38h], BUTTON_WH
    mov rcx, [rbp + 10h]
    mov qword ptr [rsp + 40h], rcx
    mov qword ptr [rsp + 48h], IDC_ADD
    mov qword ptr [rsp + 50h], 0
    mov qword ptr [rsp + 58h], 0
    xor rcx, rcx
    mov rdx, offset buttonClass
    xor r8, r8
    mov r9, WS_CHILD or WS_VISIBLE
    call CreateWindowExW

    ; close button
    mov qword ptr [rsp + 20h], W_DEFAULT - BUTTON_WH - BORDER
    mov qword ptr [rsp + 28h], BORDER
    mov qword ptr [rsp + 30h], BUTTON_WH
    mov qword ptr [rsp + 38h], BUTTON_WH
    mov rcx, [rbp + 10h]
    mov qword ptr [rsp + 40h], rcx
    mov qword ptr [rsp + 48h], IDC_EXIT
    mov qword ptr [rsp + 50h], 0
    mov qword ptr [rsp + 58h], 0
    xor rcx, rcx
    mov rdx, offset buttonClass
    xor r8, r8
    mov r9, WS_CHILD or WS_VISIBLE
    call CreateWindowExW

    ; editbox
    mov qword ptr [rsp + 20h], 0
    mov qword ptr [rsp + 28h], 0
    mov qword ptr [rsp + 30h], 0
    mov qword ptr [rsp + 38h], 0
    mov rcx, [rbp + 10h]
    mov qword ptr [rsp + 40h], rcx
    mov qword ptr [rsp + 48h], IDC_EDIT
    mov qword ptr [rsp + 50h], 0
    mov qword ptr [rsp + 58h], 0
    xor rcx, rcx
    lea rdx, [editClass]
    xor r8, r8
    mov r9, WS_CHILD or WS_VISIBLE or ES_MULTILINE or ES_AUTOVSCROLL
    call CreateWindowExW
    mov r14, rax

    mov qword ptr [rsp + 20h], FW_THIN
    mov qword ptr [rsp + 28h], 0
    mov qword ptr [rsp + 30h], 0
    mov qword ptr [rsp + 38h], 0
    mov qword ptr [rsp + 40h], DEFAULT_CHARSET
    mov qword ptr [rsp + 48h], OUT_TT_PRECIS
    mov qword ptr [rsp + 50h], CLIP_DEFAULT_PRECIS
    mov qword ptr [rsp + 58h], NONANTIALIASED_QUALITY
    mov qword ptr [rsp + 58h], ANTIALIASED_QUALITY
    mov qword ptr [rsp + 60h], DEFAULT_PITCH
    lea rax, [font]
    mov qword ptr [rsp + 68h], rax
    mov rcx, -16
    xor rdx, rdx
    xor r8, r8
    xor r9, r9
    call CreateFontW

    mov rcx, r14
    mov rdx, WM_SETFONT
    mov r8, rax
    mov r9, 1
    call SendMessageW

    mov rcx, r14
    mov rdx, EM_LIMITTEXT
    mov r8, STICKY_LENGTH
    call SendMessageW

    mov rcx, r14
    lea rdx, [sticky.text]
    call SetWindowTextW

    ; pin button
    mov qword ptr [rsp + 20h], BORDER
    mov qword ptr [rsp + 28h], BORDER
    mov qword ptr [rsp + 30h], BUTTON_WH
    mov qword ptr [rsp + 38h], BUTTON_WH
    mov rcx, [rbp + 10h]
    mov qword ptr [rsp + 40h], rcx
    mov qword ptr [rsp + 48h], IDC_PIN
    mov qword ptr [rsp + 50h], 0
    mov qword ptr [rsp + 58h], 0
    xor rcx, rcx
    mov rdx, offset buttonClass
    lea r8, [sticky.pin]
    mov r9, WS_CHILD or WS_VISIBLE
    call CreateWindowExW

    mov rcx, [rbp + 10h]
    mov rdx, HWND_TOPMOST
    cmp byte ptr [sticky.pin], "1"
    jz @pinned
    mov rdx, HWND_NOTOPMOST

@pinned:
    mov r8d, [sticky.x]
    mov r9d, [sticky.y]
    mov r10d, [sticky.w]
    mov [rsp + 20h], r10
    mov r10d, [sticky.h]
    mov [rsp + 28h], r10
    mov dword ptr [rsp + 30h], SWP_FRAMECHANGED
    call SetWindowPos

    ; focus only for new sticky
    mov r9, [rbp + 28h]
    cmp byte ptr [r9], 0
    jz @exit

    mov rcx, [rbp + 10h]
    call SetForegroundWindow

    mov rcx, r14
    call SetFocus
    jmp @exit

@WM_CTLCOLOREDIT:
    mov rcx, r8
    mov edx, BACKGROUND
    call SetBkColor

    mov rax, [hBackground]
    jmp @exit

@WM_MOUSEMOVE:
    cmp r8, MK_LBUTTON
    jnz @exit

    ; resize client area
    mov rdx, offset rect
    call GetClientRect

    mov r8, HTCAPTION

    mov r10, r9
    and r9, 0ffffh
    shr r10, 10h

    cmp r10, BUTTON_WH
    jle @nc
    sub rect.right, r9d
    sub rect.bottom, r10d

    cmp rect.bottom, EDIT_MARGIN
    jle @bottom

    cmp rect.right, EDIT_MARGIN
    jg @left
    mov r8, HTRIGHT
    jmp @nc

@left:
    cmp r9, EDIT_MARGIN
    jg @nc
    mov r8, HTLEFT
    jmp @nc


@bottom:
    mov r8, HTBOTTOMRIGHT

    cmp rect.right, EDIT_MARGIN
    jle @nc
    dec r8
    cmp r9, EDIT_MARGIN
    jle @nc
    dec r8

@nc:
    mov rcx, [rbp + 10h]
    mov rdx, WM_NCLBUTTONDOWN
    xor r9, r9
    call SendMessageW

    xor rcx, rcx
    jmp @exit

@WM_GETMINMAXINFO:
    ; min width & height
    mov [r9 + _MINMAXINFO.ptMinTrackSize.x], BUTTON_WH * 3 + BORDER * 4
    mov [r9 + _MINMAXINFO.ptMinTrackSize.y], H_DEFAULT
    jmp @exit

@WM_SETFOCUS:
    lea rdx, [sticky.id]
    mov r8, sizeof sticky.id
    call GetWindowTextW

    jmp @exit

@WM_WINDOWPOSCHANGED:
    test [r9 + _WINDOWPOS.flags], SWP_HIDEWINDOW
    jnz @delete
    test [r9 + _WINDOWPOS.flags], SWP_NOMOVE
    jz @rect
    test [r9 + _WINDOWPOS.flags], SWP_NOSIZE
    jz @resize
    test [r9 + _WINDOWPOS.flags], SWP_SHOWWINDOW
    jz @continue

@resize:
    mov r14, r9

    ; resize
    mov rcx, [rbp + 10h]
    mov rdx, IDC_EDIT
    call GetDlgItem

    mov r9d, [r14 + _WINDOWPOS.w]
    sub r9d, EDIT_RIGHT
    mov dword ptr [rsp + 20h], r9d

    mov r9d, [r14 + _WINDOWPOS.h]
    sub r9d, EDIT_BOTTOM
    mov dword ptr [rsp + 28h], r9d

    mov rcx, rax
    xor rdx, rdx
    mov r8, EDIT_LEFT
    mov r9, BUTTON_WH + EDIT_LEFT
    mov dword ptr [rsp + 30h], 0
    call SetWindowPos

    ; right alignment
    mov rcx, [rbp + 10h]
    mov rdx, IDC_EXIT
    call GetDlgItem

    mov rcx, rax
    xor rdx, rdx
    mov r8d, [r14 + _WINDOWPOS.w]
    sub r8, BUTTON_WH + BORDER
    mov r9, BORDER
    mov dword ptr [rsp + 20h], 0
    mov dword ptr [rsp + 28h], 0
    mov dword ptr [rsp + 30h], SWP_FRAMECHANGED or SWP_NOSIZE
    call SetWindowPos

    mov r9, [rbp + 28h]
    test [r9 + _WINDOWPOS.flags], SWP_SHOWWINDOW
    jnz @exit

@rect:
    xor r13, r13
    mov r14, [rbp + 28h]
    lea r14, [r14 + _WINDOWPOS.x]
    lea r15, [x]

@next:
    lea rcx, [buffer]
    lea rdx, [decimal]
    mov r8d, dword ptr [r14 + r13 * 4]
    call wsprintfW

    lea rcx, [sticky.id]
    lea rdx, [r15 + r13 * 8]
    lea r8, [buffer]
    lea r9, [file]
    call WritePrivateProfileStringW

    inc r13
    cmp r13, 4
    jnz @next

    xor rax, rax
    jmp @continue

@delete:
    lea rcx, [sticky.id]
    xor rdx, rdx
    xor r8, r8
    lea r9, [file]
    call WritePrivateProfileStringW

    jmp @exit

@WM_STICKY_PIN:
    mov rcx, [rbp + 28h]
    lea rdx, [sticky.pin]
    mov r8, sizeof sticky.pin
    call GetWindowTextW

    mov r13, HWND_TOPMOST
    mov al, "1"
    cmp byte ptr [sticky.pin], al
    jnz @change
    mov r13, HWND_NOTOPMOST
    mov al, "0"

@change:
    mov byte ptr [sticky.pin], al

    mov rcx, [rbp + 28h]
    lea rdx, [sticky.pin]
    call SetWindowTextW

    mov rcx, [rbp + 10h]
    mov rdx, r13
    mov dword ptr [rsp + 30h], SWP_FRAMECHANGED or SWP_NOSIZE or SWP_NOMOVE
    call SetWindowPos

    lea rcx, [sticky.id]
    lea rdx, [pin]
    lea r8, [sticky.pin]
    lea r9, [file]
    call WritePrivateProfileStringW

    jmp @exit

@WM_COMMAND:
    cmp r8w, IDC_EDIT
    jnz @continue
    shr r8, 10h
    cmp r8, EN_CHANGE
    jnz @continue

    mov dword ptr [sticky.text], 0

    mov rcx, [rbp + 28h]
    lea rdx, [buffer]
    mov r8, sizeof buffer
    call GetWindowTextW
    test rax, rax
    jz @empty

    lea r12, [buffer]
    lea r13, [sticky.text]
    lea r14, [rax * 2]

@byte:
    mov rcx, r13
    lea rdx, [hexadecimal]
    movzx r8, byte ptr [r12]
    call wsprintfW

    add r13, 4
    inc r12
    dec r14
    jnz @byte

@empty:
    lea rcx, [sticky.id]
    lea rdx, [text]
    lea r8, [sticky.text]
    lea r9, [file]
    call WritePrivateProfileStringW

@exit:
    mov rsp, rbp
    pop rbp
    ret

@continue:
    mov rcx, [rbp + 10h]
    mov rdx, [rbp + 18h]
    mov r8, [rbp + 20h]
    mov r9, [rbp + 28h]
    call DefWindowProcW
    jmp @exit
stickyProc endp


stickyCreate proc
    push rbp
    mov rbp, rsp
    sub rsp, 60h

    ; lpParam - focus only for new sticky
    mov qword ptr [rsp + 58h], rcx

    test rcx, rcx
    jz @old

    dec rcx
    jz @tray

    ; click in sticky
    mov eax, [rect.left]
    add eax, 50
    mov [sticky.x], eax
    mov eax, [rect.top]
    add eax, 50
    mov [sticky.y], eax
    jmp @xy

@tray:
    ; click tray
    mov eax, [workarea.right]
    mov [sticky.x], eax
    mov eax, [workarea.bottom]
    mov [sticky.y], eax

@xy:
    mov [sticky.w], W_DEFAULT
    mov [sticky.h], H_DEFAULT
    mov [sticky.pin], PIN_DEFAULT
    mov [sticky.text], 0

    ; generate id
    lea rcx, [time]
    call GetSystemTime

    lea rcx, [sticky.id]
    lea rdx, [id]
    movzx r8, word ptr [time.wYear]
    movzx r9, word ptr [time.wMonth]

    ; day, hour, minute, second, milliseconds to stack
    lea rsi, [time.wDay]
    lea rdi, [rsp + 20h]
    mov r10, 5

@next:
    lodsw
    stosq
    dec r10
    jnz @next

    call wsprintfW

@old:
    mov qword ptr [rsp + 20h], 0
    mov qword ptr [rsp + 28h], 0
    mov qword ptr [rsp + 30h], 0
    mov qword ptr [rsp + 38h], 0
    mov qword ptr [rsp + 40h], 0
    mov qword ptr [rsp + 48h], 0
    mov rax, [hInstance]
    mov qword ptr [rsp + 50h], rax

    mov rcx, WS_EX_TOOLWINDOW
    lea rdx, [stickyClass]
    lea r8, [sticky]
    mov r9, WS_POPUP or WS_CHILD or WS_BORDER
    call CreateWindowExW

    mov rcx, rax
    mov rdx, 1
    call ShowWindow

@exit:
    mov rsp, rbp
    pop rbp
    ret
stickyCreate endp


buttonProc proc
    push rbp
    mov rbp, rsp
    sub rsp, 60h

    mov [rbp + 10h], rcx    ; hwnd
    mov [rbp + 18h], rdx    ; msg
    mov [rbp + 20h], r8     ; wParam
    mov [rbp + 28h], r9     ; lParam

    cmp rdx, WM_LBUTTONDOWN
    jz @WM_LBUTTONDOWN
    cmp rdx, WM_PAINT
    jnz @continue

@WM_PAINT:
    call GetDlgCtrlID

    ; paint button icons
    cmp eax, IDC_ADD
    jnz @1
    lea r14, [iconPlus]
    jmp @3
@1: cmp eax, IDC_EXIT
    jnz @2
    lea r14, [iconExit]
    jmp @3
@2: cmp eax, IDC_PIN
    jnz @3
    lea r14, [iconPin]
@3:
    mov rcx, [rbp + 10h]
    mov rdx, offset paint
    call BeginPaint

    mov r12, [paint.hdc]
    call lineFromTo

    mov rcx, [rbp + 10h]
    mov rdx, offset paint
    call EndPaint

    jmp @exit

@WM_LBUTTONDOWN:
    call GetDlgCtrlID

    test rax, rax
    jz @exit
    cmp rax, IDC_ADD
    jz @IDC_ADD

    lea r15, [action]
    imul rax, sizeof _ACTION
    add r15, rax

    mov rcx, [rbp + 10h]
    call GetParent

    mov rcx, rax
    mov rdx, [r15 + _ACTION._rdx]
    mov r8, [r15 + _ACTION._r8]
    mov r9, [rbp + 10h]
    call SendMessageW

    jmp @exit

@IDC_ADD:
    mov rcx, [rbp + 10h]
    call GetParent

    mov rcx, rax
    mov rdx, offset rect
    call GetWindowRect

    mov rcx, 2
    call stickyCreate

@exit:
    mov rsp, rbp
    pop rbp
    ret

@continue:
    mov rcx, [rbp + 10h]
    mov rdx, [rbp + 18h]
    mov r8, [rbp + 20h]
    mov r9, [rbp + 28h]
    call DefWindowProcW
    jmp @exit
buttonProc endp

lineFromTo proc
    push rbp
    mov rbp, rsp
    sub rsp, 60h

    movzx r13, byte ptr [r14]
    inc r14

@next:
    mov rcx, r12
    mov edx, dword ptr [r14]
    mov r8d, dword ptr [r14 + 4]
    xor r9, r9
    call MoveToEx

    mov rcx, r12
    mov edx, dword ptr [r14 + 8]
    mov r8d, dword ptr [r14 + 12]
    call LineTo

    add r14, sizeof _LINE
    dec r13
    jnz @next

    mov rsp, rbp
    pop rbp
    ret
lineFromTo endp

messageAbout proc
    push rbp
    mov rbp, rsp

    xor rcx, rcx
    lea rdx, [copyright]
    lea r8, [about]
    xor r9, r9
    call MessageBoxA

    mov rsp, rbp
    pop rbp
    ret
messageAbout endp

end