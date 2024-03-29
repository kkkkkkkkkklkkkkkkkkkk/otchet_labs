format PE CONSOLE
include 'C:\Users\Andre\Downloads\fasmw17330\INCLUDE\win32ax.inc'

entry start

;========= ������� ������ ===========================================================================================================
section '.data?' data readable writeable
   x1 dd 6 dup(?)   ; ���������� ������� � 6-� ����������, ������� ����� ��������� ����� ��������.
   size_x1 = $-x1   ; ���������� ������� �������, ������� ����������� ����� ��������� x1 �� �������� ������ $.
   x2 dw 6 dup(?)   ; ���������� ������� � 6-� ����������, ������� ����� ��������� ����� ��������.
   size_x2 = $-x2   ; ���������� ������� �������, ������� ����������� ����� ��������� x1 �� �������� ������ $.
   A dw ?           ; ���������� �������������������� ���������� �, ������� �������� �� ����������� �������.


section '.data' data readable
   array1    dw 31,32,5,4,5,6          ; ���������� ������� array1 �� ���������� 31,32,5,4,5,6
   size_a1 =  $ - array1               ; ���������� ������� �������, ������� ����������� ����� ��������� array1 �� �������� ������ $.

   array2    db 1,2,3,4,5,6            ; ���������� ������� array1 �� ���������� 1,2,3,4,5,6
   size_a2 =  $ - array2               ; ���������� ������� �������, ������� ����������� ����� ��������� array2 �� �������� ������ $.

   array3 dw 7 dup(3)                  ; ���������� ������� �� 7 ������, ������ 3.
   size_a3 =  $ - array3               ; ���������� ������� �������, ������� ����������� ����� ��������� array3 �� �������� ������ $.

   array4 dw 2 dup(71,10,11)           ; ���������� ������� �� 6 ��������� ���� dw, ��� ������ ������� �������� 2 �����.
   size_a4 =  $ - array4               ; ���������� ������� �������, ������� ����������� ����� ��������� array4 �� �������� ������ $.

   size_of_dd = 4                      ; ��������� ���������� size_of_dd �� ��������� 4.

section '.msg' data readable
   msg_d db ' %d ', 0Dh, 0Ah,0                     ; ������ �������������� ��� ������ ����� �����
   msg_s db 0Dh, 0Ah,' %s ',  0Dh, 0Ah,0           ; ������ �������������� ��� ������ �����

;========= ������� ���� ===============================================================================================================
section '.code' code readable executable

macro print_array arr, arr_size, word_size         ; ������ ��� ������ ����������� �������
{
     mov ebx,0                                     ; ������� �������
     @@:                                           ; ������ �����
       cinvoke printf,  ' %d ', [arr+ebx],0        ; ����� �������� �������� �������
       add ebx,word_size                           ; ����������� ������� ������� �� �������
       cmp ebx , arr_size                          ; ���� ������� �� ������ ������� �������, �� ��������� ����.
       jne @b
}

start:
     cinvoke printf,  msg_s,'1 part',0             ; ������� ��������� �� ����� � ������� '1 part'
     cinvoke printf,  msg_d,  size_a1              ; ������� ������ ������� array1

     cinvoke printf,  msg_d, size_a2,0             ; ������� ������ ������� array2
     cinvoke printf,  msg_d, size_x1,0             ; ������� ������ ������� x1

     cinvoke printf,  msg_d, [array1+0],0          ; ������� ������ ������� ������� array1
     cinvoke printf,  msg_d, [array1+2],0          ; ������� ������ ������� ������� array1
     cinvoke printf,  msg_d, [array1+4],0          ; ������� ����� ������� ������� array1

     cinvoke printf,  msg_s,'2 part',0             ; ������� ��������� �� ����� � ������� '2 part'
     xor ebx,ebx                                   ; �������� ������� ebx
     @@:                                           ; ������ �����
       cinvoke printf,  ' %d ',  [array3+ebx],0    ; ������� ������� ������� ������� array3
       add ebx,2                                   ; ����������� ������� ebx �� 2
       cmp ebx , size_a3                           ; ���������� ������� � �������� ������� array3
       jne @b                                      ; ���� ������� �� ������ ������� �������, �� ��������� ����

     print_array array4,size_a4,2                  ; ���������� ����� ������� array4 ��� ������ �������

     cinvoke printf,  msg_s,'3 part',0             ; ������� ��������� �� ����� � ������� '3 part'
     mov ax, [array1]                              ; �������� ������ � ������� ax
     add ax, 2                                     ; ��������� � ax �������� 2
     mov [x2], ax                                  ; ���������� �������� �� ax � ���������� x2
     print_array x2, size_x2, 2                    ; ���������� ����� ������� x2 ��� ������ �������

     cinvoke printf,  msg_s,'4 part',0             ; ������� ��������� �� ����� � ������� '4 part'
     print_array x1, size_x1, size_of_dd           ; ���������� ����� �� ������� x1 ��� ������ �������

     xor ebx,ebx                                   ; �������� ������� ebx
     @@:                                           ; ������ �����
       mov [x1+ebx],ebx                            ; ��������� �������� ���������� 'ebx' � ������� ������� ������� x1
       add ebx,size_of_dd                          ; ����������� �������� ���������� 'ebx' �� ������ �������� ������� x1
       cmp ebx , size_x1                           ; ���������� 'ebx' � �������� ������� x1
       jne @b                                      ; ���� ebx != ������� �������, �� ��������� �� ����� @@

     cinvoke printf,  msg_s,'',0                   ; ������ ����� �� �����
     print_array x1, size_x1, size_of_dd           ; ���������� ����� ������� x1 ��� ������ �������

     cinvoke printf,  msg_s,'5 part',0             ; ������� ��������� �� ����� � ������� '5 part'
     cinvoke printf,  msg_s,' Enter number',0      ; ������� ��������� �� ����� � ������� 'Enter number: '
     cinvoke scanf,   ' %d', A                     ; ����������� � ������������ �����, ������� ����� ��������� � ���������� �
     mov eax, dword [A]                            ; �������� �������� ���������� � �������� 4 ����� � 'eax'
     mov [x2+2], ax                                ; ��������� �������� �������� � ������ ������� ������� x2
     print_array x2, size_x2, 2                    ; ���������� ����� ������� x2 ��� ������ �������



     invoke  sleep, 5000                           ; ������ �������� 5 ������

     invoke  exit, 0                               ; ���������� ���������
     ret                                           ; ����� �� ���������



;========= ������� ������� =========================================================================================================
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