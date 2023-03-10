format PE GUI 4.0                ; Формат PE. Версия GUI 4.0
entry start                      ; Точка входа.
include 'INCLUDE\win32ax.inc'    ; Стандартное включение.

;========= Секция данных =====================================================================

section '.data' data readable writeable
    _class db 'Simple Window',0  ; Класс окна.
    _title db 'Простое Окно',0   ; Заголовок окна.
    _error db 'Ошибка',0         ; Сообщение об ошибке.
    wc WNDCLASS 0,WindowProc,0,0,0,0,0,COLOR_BTNFACE+1,0,_class   ; Структура, описывающая класс окна.
    msg MSG
    _classb db 'BUTTON',0        ; Класс кнопки BUTTON.
    _textb db 'Кнопка А',0       ; Текст на кнопке А.
    _classb2 db 'BUTTON',0       ; Класс кнопки BUTTON.
    _textb2 db 'Кнопка B',0      ; Текст на кнопке B.
    _classb3 db 'BUTTON',0       ; Класс кнопки BUTTON.
    _textb3 db 'Кнопка C',0      ; Текст на кнопке С.
    _classb4 db 'BUTTON',0       ; Класс кнопки BUTTON.
    _textb4 db 'Кнопка D',0      ; Текст на кнопки D.
    _title_window db 'ОКНО',0    ; Заголовок окна.

;========= Секция кода ======================================================================

section '.code' code readable executable

start:
    invoke GetModuleHandle,0 ; Функция GetModuleHandle с параметром равным 0
           ; возвращает в eax идентификатор вызвавшего ее модуля.
           ; Заполнить элементы структуры wc необходимыми данными.
    mov [wc.hInstance],eax ; Идентификатор модуля поместить в wc.hInstance.
    invoke LoadIcon,[wc.hInstance],IDI_MAIN ; Функция LoadIcon с первым параметром равным 0
           ; и вторым параметром, равным константе IDI_APPLICATION
           ; загружает в класс окна стандартную иконку приложения.
    mov [wc.hIcon],eax ; Идентификатор иконки поместить в wc.hIcon.
    invoke LoadCursor,0,IDC_ARROW ; Функция LoadCursor с первым параметром равным 0
           ; и вторым параметром, равным константе IDC_ARROW
           ; загружает в класс окна стандартный курсор в форме стрелки.
    mov [wc.hCursor],eax ; Идентификатор курсора поместить в wc.hCursor.

           ; Зарегистрировать класс.
    invoke RegisterClass,wc ; Вызвать функцию RegisterClass,
           ; передав в качестве параметра указатель на структуру wc,
           ; содержащую описание класса окна.
           ; Если возвращаемое значение отлично от 0,
           ; то класс успешно зарегистрирован.
    cmp eax,0   ; Сравнить eax и 0,
    je error    ; в случае равенства перейти на метку ошибки.
           ; Создать окно.
    invoke CreateWindowEx,0,_class,_title,\ ;
    WS_VISIBLE+WS_SYSMENU,\
    128,128,256,192,0,0,[wc.hInstance],0
           ; Если возвращаемое значение отлично от 0,
           ; то окно успешно создано.
    cmp eax,0  ; Сравнить eax и 0,
    je error   ; в случае равенства перейти на метку ошибки.
           ;Цикл обработки сообщений – проверка сообщений и выход по WM_QUIT.
    msg_loop:
        invoke GetMessage,msg,NULL,0,0 ; Получить сообщение.
        cmp eax,0 ; Если получено WM_QUIT,
        je end_loop ; завершить программу.
    invoke TranslateMessage,msg  ; Преобразовать сообщения типа WM_KEYUP
                                 ; в сообщения типа WM_CHAR.
    invoke DispatchMessage,msg   ; Передать сообщение оконной процедуре.
    jmp msg_loop   ; Продолжить цикл.
    error:
        invoke MessageBox,0,_error,0,MB_ICONERROR+MB_OK ; Вывести сообщение об ошибке.
    end_loop:
        invoke ExitProcess,[msg.wParam] ; Завершить программу,
               ; возвратив операционной системе
               ; результат работы оконной процедуры.
               ; Оконная процедура WindowProc.
               ; Вызывается каждый раз при получении окном нового сообщения и передаче его через DispatchMessage.
               ; Процедура обработки сообщений WindowProc вызывается со следующими параметрами:
               ; hwnd – идентификатор окна-получателя сообщения,
               ; wmsg – код сообщения,
               ; wparam – первый параметр, определяющий дополнительные данные, связанные с сообщением.
               ; lparam – второй параметр, определяющий дополнительные данные, связанные с сообщением.
   proc WindowProc hwnd,wmsg,wparam,lparam
        push ebx esi edi
               ; При создании окно получает сообщение WM_CREATE.
        cmp [wmsg],WM_CREATE
        je .wmcreate
               ; При нажатии на кнопку окно получает сообщение WM_COMMAND.
        cmp [wmsg],WM_COMMAND
        je .wmcommand
        cmp [wmsg],WM_DESTROY
        je .wmdestroy
        .defwndproc:
            invoke DefWindowProc,[hwnd],[wmsg],[wparam],[lparam]
            jmp .finish
         .wmcreate:

            invoke CreateWindowEx,0,_classb,_textb,\  ; Создать на главном окне
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; кнопку с идентификатором 1001.
               30,20,80,50,[hwnd],1001,[wc.hInstance],NULL

            invoke CreateWindowEx,0,_classb2,_textb2,\ ; Создать на главном окне
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; кнопку с идентификатором 1002.
               120,20,80,50,[hwnd],1002,[wc.hInstance],NULL

            invoke CreateWindowEx,0,_classb3,_textb3,\ ; Создать на главном окне
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; кнопку с идентификатором 1003.
               30,80,80,50,[hwnd],1003,[wc.hInstance],NULL

            invoke CreateWindowEx,0,_classb4,_textb4,\ ; Создать на главном окне
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\     ; кнопку с индентификатором 1004.
               120,80,80,50,[hwnd],1004,[wc.hInstance],NULL

            jmp .finish
                  ; Если получили WM_COMMAND от кнопки, то wparam содержит
                  ; в старших двух байтах константу BN_CLICKED=0 (кликнута кнопка)
                  ; и в младших двух байтах идентификатор кнопки 1001,
                  ; можно считать, что весь wparam содержит идентификатор кнопки.
            .wmcommand:
                  ; Определить нажатие кнопки,
                  ; сравнивая значение wparam с 1001.
               cmp [wparam],1001 ; Если кнопка А нажата,
                jz .btn1         ; то обработать ее событие,
               cmp [wparam],1002 ; Если кнопка B нажата,
                jz .btn2         ; то обработать ее событие,
               cmp [wparam],1003 ; Если кнопка C нажата,
                jz .btn3         ; то обработать ее событие,
               cmp [wparam],1004 ; Если кнопка D нажата,
                jz .btn4         ; то обработать ее событие,
               jne .finish       ; если ни одна кнопка не нажата, то выйти из процедуры,
               ; Кнопка А
               .btn1:
                  invoke MessageBox,[hwnd],_textb,_title_window,0  ; показать MessageBox.
                  jmp .finish
               ; Кнопка B
               .btn2:
                  invoke MessageBox,[hwnd],_textb2,_title_window,0  ; показать MessageBox.
                  jmp .finish
               ; Кнопка C
               .btn3:
                  invoke MessageBox,[hwnd],_textb3,_title_window,0  ; показать MessageBox
                  jmp .finish
               ; Кнопка D
               .btn4:
                  invoke MessageBox,[hwnd],_textb4,_title_window,0  ; показать MessageBox
                  jmp .finish
               .wmdestroy:
                  invoke PostQuitMessage,0
                  mov eax,0
               .finish:
                  pop edi esi ebx
                  ret
    endp

;========= Секция импорта ======================================================================

section '.idata' import data readable writeable
    library kernel32,'KERNEL32.DLL',\
            user32,'USER32.DLL'
    include 'INCLUDE\API\kernel32.inc'
    include 'INCLUDE\API\user32.inc'

;========= Секция ресурсов ======================================================================

section '.rsrc' resource data readable
    IDI_MAIN=10

    directory RT_ICON,icons,\                    ; Выделяем иконке два типа ресурсов:
              RT_GROUP_ICON,group_icons          ; RT_ICON - тип отдельной иконки, RT_GROUP_ICON - тип ресурса,
                                                 ; связанного с одним или несколькими ресурсами типа RT_ICON.
    resource group_icons,\                    
             IDI_MAIN,LANG_NEUTRAL,main_icon     ; Группа иконок.
             
    resource icons,\                             ; Отдельная иконка.
             1,LANG_NEUTRAL,main_icon_data
    icon main_icon,main_icon_data,'icon.ico'     ; Задаем только одну пару параметров,
                                                 ; поскольку группа содержит единственную иконку.
