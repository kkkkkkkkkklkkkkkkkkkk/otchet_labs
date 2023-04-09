format PE CONSOLE
include 'C:\Users\Andre\Downloads\fasmw17330\INCLUDE\win32ax.inc'

entry start

 ;========= Сегмент данных ==========================================================================================================
section '.data?' data readable writeable
 x dd 5 dup(?)                        ; Объявление массива с 5-ю элементами, которые могут содержать любое значение
 size_x = $-x                         ; Вычисляем размер массива x


section '.data' data readable
   array    dw 31,32,5,4,5,6          ; Объявление массива array1 со значениями 31,32,5,4,5,6
   size =  $ - array                  ; Вычисление размера массива, который вычисляется путем вычитания array1 из текущего адреса $.
   size_of_dd = 4                     ; Объявляем переменную size_of_dd со значением 4.



;========= Сегмент кода ==============================================================================================================
section '.code' code readable executable

macro print_array arr, arr_size, word_size     ; Макрос для вывода содержимого массива
{
     mov ebx,0                                 ; Счетчик массива
     @@:                                       ; Начало цикла
       cinvoke printf,  ' %d ', [arr+ebx],0    ; Вывод текущего элемента массива
       add ebx,word_size                       ; Увеличиваем счетчик массива на единицу
       cmp ebx , arr_size                      ; Если счетчик не достиг размера массива, то повторяем цикл.
       jne @b
}

start:
    print_array array,size,2         ; Используем вывод массива array4 при помощи макроса

    mov esi, array                   ; Загружаем адрес массива в esi
    mov ecx, size                    ; Загружаем размер массива в ecx

outer_loop:
    mov ebx, esi                     ; Загружаем адрес массива в ebx
    add ebx, 1                       ; Увеличиваем адрес на 1 байт
    mov edx, ecx                     ; Загружаем размер массива в регистр edx
    dec edx                          ; Уменьшаем размер массива на 1


inner_loop:
    mov al, byte [esi]               ; Загружаем текущий элемент массива в al
    cmp al, byte [ebx]               ; Сравниваем текущий элемент с следующим
    jle skip_swap                    ; Если текущий элемент меньше или равен, то пропускаем обмен
    xchg al, byte [ebx]              ; Меняем местами текущий элемент в памяти
    mov byte [esi], al               ; Сохраняем текущий элемент в память
    mov byte [ebx], al               ; Сохраняем следующий элемент в память

skip_swap:
    add esi, 1                       ; Увеличиваем адрес на 1 байт
    add ebx, 1                       ; Увеличиваем адрес на 1 байт
    dec edx                          ; Уменьшаем размер массива на 1
    jnz inner_loop                   ; Если размер массива равен 0 переходим на inner_loop

    dec ecx                          ; Уменьшаем размер массива на 1
    jnz outer_loop                   ; Если размер массива не равен 0, переходим на outer_loop

    mov [x], ecx                     ; Помещаем массив в переменную x
    print_array array,size_x,2       ; Используем вывод массива x при помощи макроса

    invoke sleep, 5000               ; Делаем задержку 5 секунд
    invoke exit, 0                   ; Завершение программы
    ret                              ; Выход из процедуры

;========= Таблица импорта ==========================
section '.idata' import data readable
 
 library msvcrt,'MSVCRT.DLL',\
    kernel32,'KERNEL32.DLL'
 
 import kernel32,\
    sleep,'Sleep'
 
 import msvcrt,\
    puts,'puts',\
    scanf,'scanf',\
    printf,'printf',\
    lstrlen,'lstrlenA',\
    exit,'exit'