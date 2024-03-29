format PE CONSOLE   ; ���������� ����������
entry start         ; ����� �����
include 'C:\Users\GamerPC\Downloads\fasmw17330\INCLUDE\win32ax.inc'   ; ����������� ���������

;========= ������� ������ =====================================================================

section '.data?' data readable writeable
        A    dd ?                                         ; ��������� ������������������� A
        B    dd ?                                         ; ��������� ������������������� B
        C    dd ?                                         ; ��������� ������������������� C
        D    dd ?                                         ; ��������� ������������������� D

section '.data' data readable
        answ    db  'A+B+1 = %d',0                        ; ��������� ��������� ����������

;========= ������� ���� =======================================================================

section '.code' code readable executable

; ������� ������, ������� ��������� ���������� �������� � ����
macro mov_zero op1
{
      mov op1,0
}

; ��������� ��������� � ��������� add2val � ����������� val1, val2.
; ��������� ��������� �������� ���� ����������.
proc add2val, val1, val2
     mov eax,[val1]
     add eax,[val2]
     ret
endp

start:

     cinvoke puts,    'Enter A ', 0                  ; ������� � ������� ����� 'Enter A'
     cinvoke scanf,   '%d', A    ;  A                ; �������� �������� �� ������������ �
                                                     ; ���������� � ���������� �.
     cinvoke printf,  'Enter B ', 0                  ; ������� � ������� ����� 'Enter B'
     cinvoke scanf,   '%d', B    ;  A                ; �������� �������� �� ������������ �
                                                     ; ���������� � ���������� B.

     mov eax,[A]                                     ; ��������� �������� ���������� � � eax
     add eax,[B]                                     ; �������� � eax �������� ���������� B
     lea ebx,[eax]                                   ; �������� �������� � ������ � ������� �������
     xchg ecx,ebx                                    ; ������ ������������ ecx � ebx �������
     inc  ecx                                        ; ��������� ecx �� �������
     mov [C],ecx                                     ; ����������� �� ecx � ���������� C
     cinvoke printf, answ , [C],0                    ; ������� ��������� �������� �� �����

     mov eax,[A]                                     ; ���������� ���������� � � eax
     mov ebx,[B]                                     ; ���������� ���������� B � ebx
     imul ebx, eax                                   ; ������� ������������ eax � ebx
     cinvoke printf, '  mull = %d   ' , ebx,0        ; ������� �������� ��������� ���� ����������

     mov edx, [C]                                    ; ���������� �� ���������� C � edx
     mov_zero ecx

     .repeat                                         ; �������� �����
        add edx,10                                   ; � edx ���������� 10
        inc ecx                                      ; ��������� � ecx �������
     .until edx>130                                  ; ����� �� ����� ���������� ��� edx>130

     mov [D],ecx                                     ; ���������� �� ecx � ���������� D
     cinvoke printf, ' D  %d  ' , [D],0              ; ����� ���������� D �� �����

     mov_zero ebx                                    ; �������� � ������ ebx
     cinvoke printf, 'mov_zero   %d  ' , ebx,0       ; ������� ��������� �� �����

     stdcall add2val, 10, 2                          ; ������ ��� ������ ���������, � �������
                                                     ; �������� �������� 10 � 2.
     cinvoke printf, ' add2reg  %d  ' , eax,0        ; ������� ��������� �� �����


     invoke  sleep, 10000                            ; ������ �������� ���� 10 ������

     invoke  exit, 0                                 ; ���������� ���������
     ret                                             ; ������� �� ��������� ���������

;========= ������� ������� ====================================================================

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