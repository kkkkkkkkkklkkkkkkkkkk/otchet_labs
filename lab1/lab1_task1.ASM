format PE GUI 4.0                ; Формат PE. Версия GUI 4.0
entry start                      ; Точка входа.
include 'INCLUDE\win32ax.inc' ; Стандартное включение

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
    include 'INCLUDE\API\kernel32.inc'
    include 'INCLUDE\API\user32.inc'
