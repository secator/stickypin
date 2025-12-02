STICKY_LENGTH = 255
BORDER = 1
BACKGROUND = 0D1F7FFh

ICON_PEN = 3
ICON_PADDING = 7

BUTTON_WH = 32

IDC_EXIT = 1
IDC_PIN = 2
IDC_ADD = 3
IDC_EDIT = 4

PIN_DEFAULT = 0
X_DEFAULT = 200
Y_DEFAULT = 100
W_DEFAULT = 300
H_DEFAULT = 100

PS_SOLID = 0

_LINE STRUCT
    x1 dd 0
    y1 dd 0
    x2 dd 0
    y2 dd 0
_LINE ENDS

_RECT STRUCT
    left dd ?
    top dd ?
    right dd ?
    bottom dd ?
_RECT ENDS

_PAINT STRUCT
    hdc dq ?
    fErase dd ?
    rcPaint _RECT <>
    fRestore dd ?
    fIncUpdate dd ?
    rgbReserved db 32 dup (?)
_PAINT ENDS

_NOTIFYICONDATAA STRUCT
    cbSize dd ?
    hWnd dq ?
    uID dd ?
    uFlags dd ?
    uCallbackMessage dd ?
    hIcon dq ?
    szTip dw 64 dup (?)
    dwState dd ?
    dwStateMask dd ?
    szInfo db 256 dup (?)
    uVersion dd ?
    szInfoTitle db 64 dup (?)
    dwInfoFlags dd ?
    guidItem db 16 dup (?)
    hBalloonIcon dq ?
_NOTIFYICONDATAA ENDS

_ICONINFO STRUCT
    fIcon dd ?
    xHotspot dd ?
    yHotspot dd ?
    hbmMask dq ?
    hbmColor dq ?
_ICONINFO ENDS

_WNDCLASSW STRUCT
    style dd ?
    lpfnWndProc dq ?
    cbClsExtra dd ?
    cbWndExtra dd ?
    hInstance dq ?
    hIcon dq ?
    hCursor dq ?
    hbrBackground dq ?
    lpszMenuName dq ?
    lpszClassName dq ?
_WNDCLASSW ENDS

_MSG STRUCT
    hwnd dq ?
    message dd ?
    wParam dq ?
    lParam dq ?
    time dd ?
    pt dq ?
    lPrivate dd ?
_MSG ENDS

_POINT STRUCT
    x dd ?
    y dd ?
_POINT ENDS

_MINMAXINFO STRUCT
    ptReserved _POINT <>
    ptMaxSize _POINT <>
    ptMaxPosition _POINT <>
    ptMinTrackSize _POINT <>
    ptMaxTrackSize _POINT <>
_MINMAXINFO ENDS

_STICKY STRUCT
    id dw 24 dup (?)
    x dd ?
    y dd ?
    w dd ?
    h dd ?
    pin dd ?
    text dw STICKY_LENGTH*4+4 dup (?)
_STICKY ENDS

_ACTION STRUCT
    _rdx dq ?
    _r8 dq ?
    _r9 dq ?
_ACTION ENDS

_SYSTEMTIME STRUCT
    wYear dw ?
    wMonth dw ?
    wDayOfWeek dw ?
    wDay dw ?
    wHour dw ?
    wMinute dw ?
    wSecond dw ?
    wMilliseconds dw ?
_SYSTEMTIME ENDS

_WINDOWPOS STRUCT
    hwnd dq ?
    hwndInsertAfter dq ?
    x dd ?
    y dd ?
    w dd ?
    h dd ?
    flags dd ?
_WINDOWPOS ENDS

IDC_ARROW = 32512

CS_VREDRAW = 1
CS_HREDRAW = 2

CW_USEDEFAULT = 080000000h

WM_CREATE = 0001h
WM_SETFOCUS = 0007h
WM_PAINT = 000Fh
WM_CLOSE = 0010h
WM_GETMINMAXINFO = 00024h
WM_SETFONT = 00030h
WM_WINDOWPOSCHANGED = 00047h
WM_COMMAND = 00111h
WM_CTLCOLOREDIT = 0133h
WM_MOUSEMOVE = 0200h
WM_USER = 0400h

WM_NOTIFY_ICON = WM_USER + 1
WM_STICKY_PIN = WM_USER + 2

WM_LBUTTONDOWN = 00201h
WM_LBUTTONDBLCLK = 00203h
MK_LBUTTON = 00001h

WM_MBUTTONDOWN  = 00207h

WM_RBUTTONDOWN = 00204h
WM_RBUTTONDBLCLK = 00206h

WM_NCLBUTTONDOWN = 000A1h

EM_LIMITTEXT = 000C5h

HTCAPTION = 2
HTLEFT = 10
HTRIGHT = 11
HTBOTTOMRIGHT = 17

NIF_MESSAGE = 000000001
NIF_ICON = 00000002
NIF_TIP = 00000004
NIF_SHOWTIP  = 00000080h
NIF_INFO = 000000010h

NIM_ADD = 0
NIM_SETVERSION  = 4

WS_BORDER = 000800000h
WS_CHILD = 040000000h
WS_POPUP = 080000000h
WS_EX_TOOLWINDOW = 00000080h
WS_VISIBLE = 010000000h

ES_MULTILINE = 00004h
ES_AUTOVSCROLL = 00040h

FW_THIN = 100
DEFAULT_CHARSET = 1
OUT_TT_PRECIS = 4
CLIP_DEFAULT_PRECIS = 0
NONANTIALIASED_QUALITY = 3
ANTIALIASED_QUALITY = 4
DEFAULT_PITCH = 0

EDIT_MARGIN = 10
EDIT_LEFT = 10
EDIT_RIGHT = EDIT_LEFT * 2
EDIT_BOTTOM = 50

SWP_NOSIZE = 0001h
SWP_NOMOVE = 0002h
SWP_NOZORDER = 0004h
SWP_FRAMECHANGED = 00020h
SWP_NOOWNERZORDER = 00200h
SWP_SHOWWINDOW = 0040h
SWP_HIDEWINDOW = 0080h

EN_CHANGE = 00300h

HWND_TOPMOST = -1
HWND_TOP = 0
HWND_NOTOPMOST = -2

SPI_GETWORKAREA = 00030h
