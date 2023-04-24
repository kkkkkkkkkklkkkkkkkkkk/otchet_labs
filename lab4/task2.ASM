format PE CONSOLE
include 'C:\Users\GamerPC\Downloads\fasmw17330\INCLUDE\win32ax.inc'

entry start

;============== Сегмент данных ==============================================================================
section '.data?' data readable writeable

   x1 db 256 dup(?)    ; Объявление массива с 255-ю элементами, которые могут содержать любые значения.
   x2 rb 256           ; Объявление переменной x2
   x3 rd 256           ; Объявление переменной x3
   len_x dd ?          ; Объявление неинициализированной переменной len_x

;============== Сегмент CRC8  ===============================================================================
section '.CRC8' data readable writeable

        msg_hex db 'hex = %Xh ', 0Dh, 0Ah,0     ; Объявление строки для вывода значения в 16-ой форме.


;============== Сегмент вывода ==============================================================================
section '.msg' data readable

   msg_d db ' %d ', 0Dh, 0Ah,0              ; Строка форматированиЯ для вывода целых чисел.
   msg_s db 0Dh, 0Ah,' %s ',  0Dh, 0Ah,0    ; Строка форматирования для вывода строк.

;============== Сегмент кода ==============================================================================
section '.code' code readable executable

start:
     cinvoke printf,msg_s, 'Enter string of char',0   ; Выводит на экран сообщение 'Enter string of char'
     cinvoke scanf,   ' %s', x1                 ; Считывает строку символов из ввода пользователя и сохраняет
                                                ;  ее в переменную x1.
     cinvoke strlen,x1                          ; Вычисляет длину строки, сохраняет результат в регистр eax
     mov [len_x], eax                           ; Сохраняет значение длины строки в переменной len_x
     cinvoke printf,msg_d, [len_x],0            ; Выводит на экран значение длины строки

     xor ecx, ecx                               ; Обнуляет счетчик цикла.
     @@:                                        ; Метка начала цикла.
        mov bl, [x1+ecx]                        ; Загружает байт из строки в регистр bl.
        mov [x2+ecx], bl                        ; Сохраняет байт в новой строке x2.
        inc ecx                                 ; Увеличивает счетчик цикла на 1
        cmp ecx,[len_x]                         ; Сравнивает счетчик цикла с длиной строки.
        jne @b                                  ; Переходит к метке @@, если счетчик цикла меньше длины строки.
     cinvoke printf,msg_s, x2,0                 ; Выводит на экран новую строку x2.

     xor ecx, ecx                               ; Обнуляет счетчик цикла.
     @@:                                        ; Метка начала цикла.
        mov bl, [x2+ecx]                        ; Загружает байт из новой строки x2 в регистр bl
        inc ecx                                 ; Увеличивает счетчик цикла на 1.
        cmp bl, 0                               ; Сравнивает значение регистра bl с 0.
        jne @b                                  ; Переходит к метке @@, если значение регистра bl != 0
     sub ecx,1                                  ; Вычитает из счетчика цикла единицу.
     cinvoke printf,msg_d, ecx,0                ; Выводит на экран количество символов в новой строке x2

     xor ecx, ecx                               ; Обнуляет счетчик цикла.
     @@:                                        ; Метка начала цикла.
        xor ebx,ebx                             ; Обнуляет регистр ebx.
        mov bl, [x1+ecx]                        ; Загружает байт из исходной строки x1 в регистр bl.
        mov [x3+ecx], ebx                       ; Сохраняет байт в новой строке x3
        inc ecx                                 ; Увеличивает счетчик цикла на 1
        cmp ecx,[len_x]                         ; Сравнивает счетчик цикла с длиной строки.
        jne @b                                  ; Переходит к метке @@, если счетчик цикла меньше длины строки.
     cinvoke printf,msg_s, x3,0                 ; Выводит на экран новую строку x3

     xor ecx, ecx                               ; Обнуляет счетчик цикла
     @@:                                        ; Метка начала цикла
        mov ebx, [x3+ecx]                       ; Загружает байт из новой строки x3 в регистр ebx.
        inc ecx                                 ; Увеличивает счетчик цикла на 1
        cmp ebx, 0                              ; Сравнивает значение регистра ebx с нулем.
        jne @b                                  ; Переходит к метке @@, если значение регистра ebx != 0
     sub ecx,1                                  ; Вычитает из счетчика цикла единицу.
     cinvoke printf,msg_d, ecx,0                ; Выводит на экран количество символов в новой строке x3.


     cinvoke printf,msg_s, '',0                 ; Выводит на экран пустую строку.

     cinvoke printf,msg_s, 'CRC8',0             ; Выводит на экран сообщение 'CRC8'.
     stdcall CRC8, x1,len_x                     ; Вызывает процедуру CRC8Calc для вычисления CRC8 для строки
     cinvoke printf,msg_hex, eax,0

     invoke  sleep, 5000                        ; Зарежка 5 секунд

     invoke  exit, 0                            ; Завершение и выход из программы.
     ret

proc    CRC8 lpData:DWORD, dSize:DWORD
        push    ebx ecx edx esi edi
 
        CRC8_POLYNOM = 31h

        mov     al,0FFh

        cmp     [dSize],0
        je      .loc_ret

        xor     ecx,ecx
@@:
        mov     ebx,[lpData]
        xor     al,byte [ebx+ecx]
 
        xor     esi,esi
.loc_cycle:
        test    al,80h
        jz      .loc_1
 
        shl     al,1
        xor     al,CRC8_POLYNOM
        jmp     .loc_next
.loc_1:
        shl     al,1
.loc_next:
        inc     esi
        cmp     esi,8
        jb      .loc_cycle

        inc     ecx
        cmp     ecx,[dSize]
        jb      @b
 
.loc_ret:
        and     eax,0FFh
 
        pop     edi esi edx ecx ebx
        ret
endp

;============== Таблица импорта ==============================================================================
section '.idata' import data readable
 
 library msvcrt,'MSVCRT.DLL',\
    kernel32,'KERNEL32.DLL'
 
 import kernel32,\
    sleep,'Sleep'
 
 import msvcrt,\
    puts,'puts',\
    scanf,'scanf',\
    printf,'printf',\
    strlen,'strlen',\
    exit,'exit'