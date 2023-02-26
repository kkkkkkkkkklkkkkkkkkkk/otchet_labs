format PE GUI 4.0                ; Ôîðìàò PE. Âåðñèÿ GUI 4.0
entry start                      ; Òî÷êà âõîäà.
include 'C:\Users\GamerPC\Downloads\fasmw17330\INCLUDE\win32ax.inc' ; Ñòàíäàðòíîå âêëþ÷åíèå.

;========= Секция данных =====================================================================

section '.data' data readable writeable
    Caption db 'Первая программа',0
    Text db 'Нажмите Да',0

;========= Секция кода ======================================================================

section '.code' code readable executable
start:
    invoke MessageBox,0,Text,Caption,MB_YESNO
    invoke ExitProcess,0

;========= Секция импорта ======================================================================

section '.idata' import data readable writeable
    library kernel32,'KERNEL32.DLL',\
            user32,'USER32.DLL'
    include 'C:\Users\GamerPC\Downloads\fasmw17330\INCLUDE\API\kernel32.inc'
    include 'C:\Users\GamerPC\Downloads\fasmw17330\INCLUDE\API\user32.inc'
