format PE GUI 4.0                ; ������ PE. ������ GUI 4.0
entry start                      ; ����� �����.
include 'C:\Users\GamerPC\Downloads\fasmw17330\INCLUDE\win32ax.inc' ; ����������� ���������.

;========= ������� ������ =====================================================================

section '.data' data readable writeable
    _class db 'Simple Window',0  ; ����� ����.
    _title db '������� ����',0   ; ��������� ����.
    _error db '������',0         ; ��������� �� ������.
    wc WNDCLASS 0,WindowProc,0,0,0,0,0,COLOR_BTNFACE+1,0,_class   ; ���������, ����������� ����� ����.
    msg MSG
    _classb db 'BUTTON',0        ; ����� ������ BUTTON.
    _textb db '������ �',0       ; ����� �� ������ �.
    _classb2 db 'BUTTON',0       ; ����� ������ BUTTON.
    _textb2 db '������ B',0      ; ����� �� ������ B.
    _classb3 db 'BUTTON',0       ; ����� ������ BUTTON.
    _textb3 db '������ C',0      ; ����� �� ������ �.
    _classb4 db 'BUTTON',0       ; ����� ������ BUTTON.
    _textb4 db '������ D',0      ; ����� �� ������ D.
    _title_window db '����',0    ; ��������� ����.

;========= ������� ���� ======================================================================

section '.code' code readable executable

start:
    invoke GetModuleHandle,0 ; ������� GetModuleHandle � ���������� ������ 0
           ; ���������� � eax ������������� ���������� �� ������.
           ; ��������� �������� ��������� wc ������������ �������.
    mov [wc.hInstance],eax ; ������������� ������ ��������� � wc.hInstance.
    invoke LoadIcon,[wc.hInstance],IDI_MAIN ; ������� LoadIcon � ������ ���������� ������ 0
           ; � ������ ����������, ������ ��������� IDI_APPLICATION
           ; ��������� � ����� ���� ����������� ������ ����������.
    mov [wc.hIcon],eax ; ������������� ������ ��������� � wc.hIcon.
    invoke LoadCursor,0,IDC_ARROW ; ������� LoadCursor � ������ ���������� ������ 0
           ; � ������ ����������, ������ ��������� IDC_ARROW
           ; ��������� � ����� ���� ����������� ������ � ����� �������.
    mov [wc.hCursor],eax ; ������������� ������� ��������� � wc.hCursor.

           ; ���������������� �����.
    invoke RegisterClass,wc ; ������� ������� RegisterClass,
           ; ������� � �������� ��������� ��������� �� ��������� wc,
           ; ���������� �������� ������ ����.
           ; ���� ������������ �������� ������� �� 0,
           ; �� ����� ������� ���������������.
    cmp eax,0   ; �������� eax � 0,
    je error    ; � ������ ��������� ������� �� ����� ������.
           ; ������� ����.
    invoke CreateWindowEx,0,_class,_title,\ ;
    WS_VISIBLE+WS_SYSMENU,\
    128,128,256,192,0,0,[wc.hInstance],0
           ; ���� ������������ �������� ������� �� 0,
           ; �� ���� ������� �������.
    cmp eax,0  ; �������� eax � 0,
    je error   ; � ������ ��������� ������� �� ����� ������.
           ;���� ��������� ��������� � �������� ��������� � ����� �� WM_QUIT.
    msg_loop:
        invoke GetMessage,msg,NULL,0,0 ; �������� ���������.
        cmp eax,0 ; ���� �������� WM_QUIT,
        je end_loop ; ��������� ���������.
    invoke TranslateMessage,msg  ; ������������� ��������� ���� WM_KEYUP
                                 ; � ��������� ���� WM_CHAR.
    invoke DispatchMessage,msg   ; �������� ��������� ������� ���������.
    jmp msg_loop   ; ���������� ����.
    error:
        invoke MessageBox,0,_error,0,MB_ICONERROR+MB_OK ; ������� ��������� �� ������.
    end_loop:
        invoke ExitProcess,[msg.wParam] ; ��������� ���������,
               ; ��������� ������������ �������
               ; ��������� ������ ������� ���������.
               ; ������� ��������� WindowProc.
               ; ���������� ������ ��� ��� ��������� ����� ������ ��������� � �������� ��� ����� DispatchMessage.
               ; ��������� ��������� ��������� WindowProc ���������� �� ���������� �����������:
               ; hwnd � ������������� ����-���������� ���������,
               ; wmsg � ��� ���������,
               ; wparam � ������ ��������, ������������ �������������� ������, ��������� � ����������.
               ; lparam � ������ ��������, ������������ �������������� ������, ��������� � ����������.
   proc WindowProc hwnd,wmsg,wparam,lparam
        push ebx esi edi
               ; ��� �������� ���� �������� ��������� WM_CREATE.
        cmp [wmsg],WM_CREATE
        je .wmcreate
               ; ��� ������� �� ������ ���� �������� ��������� WM_COMMAND.
        cmp [wmsg],WM_COMMAND
        je .wmcommand
        cmp [wmsg],WM_DESTROY
        je .wmdestroy
        .defwndproc:
            invoke DefWindowProc,[hwnd],[wmsg],[wparam],[lparam]
            jmp .finish
         .wmcreate:

            invoke CreateWindowEx,0,_classb,_textb,\  ; ������� �� ������� ����
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; ������ � ��������������� 1001.
               30,20,80,50,[hwnd],1001,[wc.hInstance],NULL

            invoke CreateWindowEx,0,_classb2,_textb2,\ ; ������� �� ������� ����
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; ������ � ��������������� 1002.
               120,20,80,50,[hwnd],1002,[wc.hInstance],NULL

            invoke CreateWindowEx,0,_classb3,_textb3,\ ; ������� �� ������� ����
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; ������ � ��������������� 1003.
               30,80,80,50,[hwnd],1003,[wc.hInstance],NULL

            invoke CreateWindowEx,0,_classb4,_textb4,\ ; ������� �� ������� ����
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\     ; ������ � ���������������� 1004.
               120,80,80,50,[hwnd],1004,[wc.hInstance],NULL

            jmp .finish
                  ; ���� �������� WM_COMMAND �� ������, �� wparam ��������
                  ; � ������� ���� ������ ��������� BN_CLICKED=0 (�������� ������)
                  ; � � ������� ���� ������ ������������� ������ 1001,
                  ; ����� �������, ��� ���� wparam �������� ������������� ������.
            .wmcommand:
                  ; ���������� ������� ������,
                  ; ��������� �������� wparam � 1001.
               cmp [wparam],1001 ; ���� ������ � ������,
                jz .btn1         ; �� ���������� �� �������,
               cmp [wparam],1002 ; ���� ������ B ������,
                jz .btn2         ; �� ���������� �� �������,
               cmp [wparam],1003 ; ���� ������ C ������,
                jz .btn3         ; �� ���������� �� �������,
               cmp [wparam],1004 ; ���� ������ D ������,
                jz .btn4         ; �� ���������� �� �������,
               jne .finish       ; ���� �� ���� ������ �� ������, �� ����� �� ���������,
               ; ������ �
               .btn1:
                  invoke MessageBox,[hwnd],_textb,_title_window,0  ;  �������� MessageBox.
                  jmp .finish
               ; ������ B
               .btn2:
                  invoke MessageBox,[hwnd],_textb2,_title_window,0  ;  �������� MessageBox.
                  jmp .finish
               ; ������ C
               .btn3:
                  invoke MessageBox,[hwnd],_textb3,_title_window,0  ;  �������� MessageBox
                  jmp .finish
               ; ������ D
               .btn4:
                  invoke MessageBox,[hwnd],_textb4,_title_window,0  ;  �������� MessageBox
                  jmp .finish
               .wmdestroy:
                  invoke PostQuitMessage,0
                  mov eax,0
               .finish:
                  pop edi esi ebx
                  ret
    endp

;========= ������� ������� ======================================================================

section '.idata' import data readable writeable
    library kernel32,'KERNEL32.DLL',\
            user32,'USER32.DLL'
    include 'C:\Users\GamerPC\Downloads\fasmw17330\INCLUDE\API\kernel32.inc'
    include 'C:\Users\GamerPC\Downloads\fasmw17330\INCLUDE\API\user32.inc'

;========= ������ �������� ======================================================================

section '.rsrc' resource data readable
    IDI_MAIN=10

    directory RT_ICON,icons,\
              RT_GROUP_ICON,group_icons
    resource group_icons,\
             IDI_MAIN,LANG_NEUTRAL,main_icon
    resource icons,\
             1,LANG_NEUTRAL,main_icon_data
    icon main_icon,main_icon_data,'icon.ico'