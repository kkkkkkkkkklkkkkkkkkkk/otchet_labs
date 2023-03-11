format PE CONSOLE   ; Консольное приложение
entry start         ; Точка входа
include 'C:\Users\GamerPC\Downloads\fasmw17330\INCLUDE\win32ax.inc'   ; Стандартное включение

;========= Сегмент данных =====================================================================

section '.data?' data readable writeable
        A    dd ?                                         ; Объявляем неиницилизированную A
        B    dd ?                                         ; Объявляем неиницилизированную B
        C    dd ?                                         ; Объявляем неиницилизированную C
        D    dd ?                                         ; Объявляем неиницилизированную D

section '.data' data readable
        answ    db  'A+B+1 = %d',0                        ; Объявляем текстовую переменную

;========= Сегмент кода =======================================================================

section '.code' code readable executable

; Создаем макрос, который переводит полученный параметр в ноль
macro mov_zero op1
{
      mov op1,0
}

; Объявляем процедуру с названием add2val и параметрами val1, val2.
; Процедура выполняет сложение двух параметров.
proc add2val, val1, val2
     mov eax,[val1]
     add eax,[val2]
     ret
endp

start:

     cinvoke puts,    'Enter A ', 0                  ; Выводим в консоль текст 'Enter A'
     cinvoke scanf,   '%d', A    ;  A                ; Получаем значение от пользователя и
                                                     ; записываем в переменную А.
     cinvoke printf,  'Enter B ', 0                  ; Выводим в консоль текст 'Enter B'
     cinvoke scanf,   '%d', B    ;  A                ; Получаем значение от пользователя и
                                                     ; записываем в переменную B.

     mov eax,[A]                                     ; Поместить значение переменной А в eax
     add eax,[B]                                     ; Добавить в eax значение переменной B
     lea ebx,[eax]                                   ; Операция сложения и запись в базовый регистр
     xchg ecx,ebx                                    ; Делаем перестановку ecx и ebx местами
     inc  ecx                                        ; Увеличить ecx на единицу
     mov [C],ecx                                     ; Переместить из ecx в переменную C
     cinvoke printf, answ , [C],0                    ; Вывести результат сложения на экран

     mov eax,[A]                                     ; Перемещаем переменную А в eax
     mov ebx,[B]                                     ; Перемещаем переменную B в ebx
     imul ebx, eax                                   ; Находим произведение eax и ebx
     cinvoke printf, '  mull = %d   ' , ebx,0        ; Выводим резульат умножение двух переменных

     mov edx, [C]                                    ; Перемещаем из переменной C в edx
     mov_zero ecx

     .repeat                                         ; Создание цикла
        add edx,10                                   ; К edx прибавляем 10
        inc ecx                                      ; Прибавить к ecx единицу
     .until edx>130                                  ; Выход из цикла происходит при edx>130

     mov [D],ecx                                     ; Перемещаем из ecx в переменную D
     cinvoke printf, ' D  %d  ' , [D],0              ; Вывод переменной D на экран

     mov_zero ebx                                    ; Передаем в макрос ebx
     cinvoke printf, 'mov_zero   %d  ' , ebx,0       ; Выводим результат на экран

     stdcall add2val, 10, 2                          ; Макрос для вызова процедуры, в который
                                                     ; передаем значения 10 и 2.
     cinvoke printf, ' add2reg  %d  ' , eax,0        ; Выводим результат на экран


     invoke  sleep, 10000                            ; Держим активное окно 10 секунд

     invoke  exit, 0                                 ; Завершение программы
     ret                                             ; Возврат из ближайшей процедуры

;========= Таблица импорта ====================================================================

section '.idata' import data readable
 
 library msvcrt,'MSVCRT.DLL',\
    kernel32,'KERNEL32.DLL'
 
 import kernel32,\
    sleep,'Sleep'
 
 import msvcrt,\
    puts,'puts',\
    scanf,'scanf',\
    printf,'printf',\
    exit,'exit'